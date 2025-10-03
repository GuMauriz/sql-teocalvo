-- CREATE TABLE feature_store_clientes AS

-- Quantidade de transações históricas (vida, D7, D14, D28, D56);
WITH tb_transacoes AS (
    SELECT
        IdTransacao,
        IdCliente,
        QtdePontos,
        DATETIME(SUBSTR(DtCriacao, 1, 19)) AS DtCriacao,
        JULIANDAY('{date}') - JULIANDAY(SUBSTR(DtCriacao, 1, 10)) AS DiffDate,
        CAST(STRFTIME('%H', SUBSTR(DtCriacao, 1, 19)) AS INTEGER) AS DtHora
    FROM transacoes
    WHERE SUBSTR(DtCriacao, 1, 10) <= '{date}'
),

tb_sumario_transacoes AS (
    SELECT
        IdCliente,
        COUNT(IdTransacao) AS QtdeTransacoesLifeTime,
        COUNT(CASE WHEN DiffDate <= 7 THEN IdTransacao END) AS QtdeTransacoesD7,
        COUNT(CASE WHEN DiffDate <= 14 THEN IdTransacao END) AS QtdeTransacoesD14,
        COUNT(CASE WHEN DiffDate <= 28 THEN IdTransacao END) AS QtdeTransacoesD28,
        COUNT(CASE WHEN DiffDate <= 56 THEN IdTransacao END) AS QtdeTransacoes56,
        -- Dias desde a última transação
        MIN(DiffDate) AS DiasDesdeUltimaTransacao,
        -- Saldo de pontos
        SUM(QtdePontos) AS SaldoPontos,
        -- Pontos acumulados positivos (vida, D7, D14, D28, D56);
        SUM(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS PtsPosAcumLifeTime,
        SUM(CASE WHEN QtdePontos > 0 AND DiffDate <= 7 THEN QtdePontos ELSE 0 END) AS PtsPosAcumD7,
        SUM(CASE WHEN QtdePontos > 0 AND DiffDate <= 14 THEN QtdePontos ELSE 0 END) AS PtsPosAcumD14,
        SUM(CASE WHEN QtdePontos > 0 AND DiffDate <= 28 THEN QtdePontos ELSE 0 END) AS PtsPosAcumD28,
        SUM(CASE WHEN QtdePontos > 0 AND DiffDate <= 56 THEN QtdePontos ELSE 0 END) AS PtsPosAcumD56,
        -- Pontos acumulados negativos (vida, D7, D14, D28, D56);
        SUM(CASE WHEN QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS PtsNegAcumLifeTime,
        SUM(CASE WHEN QtdePontos < 0 AND DiffDate <= 7 THEN QtdePontos ELSE 0 END) AS PtsNegAcumD7,
        SUM(CASE WHEN QtdePontos < 0 AND DiffDate <= 14 THEN QtdePontos ELSE 0 END) AS PtsNegAcumD14,
        SUM(CASE WHEN QtdePontos < 0 AND DiffDate <= 28 THEN QtdePontos ELSE 0 END) AS PtsNegAcumD28,
        SUM(CASE WHEN QtdePontos < 0 AND DiffDate <= 56 THEN QtdePontos ELSE 0 END) AS PtsNegAcumD56
    FROM tb_transacoes
    GROUP BY IdCliente
),

-- Idade do cliente (dias desde a criação do cliente)
tb_idade_clientes AS (
    SELECT
        IdCliente,
        DATETIME(SUBSTR(DtCriacao, 1, 19)) AS DtCriacaoFix,
        JULIANDAY('{date}') - JULIANDAY(SUBSTR(DtCriacao, 1, 10)) AS IdadeCliente
    FROM clientes
),

-- Produto mais usado (vida, D7, D14, D28, D56);
tb_produtos_mais_usados AS (
    SELECT 
        A.IdCliente,
        C.DescNomeProduto,
        COUNT(A.IdTransacao) AS QtdeUsoProdutoLifeTime,
        COUNT(CASE WHEN A.DiffDate <= 7 THEN A.IdTransacao END) AS QtdeUsoProdutoD7,
        COUNT(CASE WHEN A.DiffDate <= 14 THEN A.IdTransacao END) AS QtdeUsoProdutoD14,
        COUNT(CASE WHEN A.DiffDate <= 28 THEN A.IdTransacao END) AS QtdeUsoProdutoD28,
        COUNT(CASE WHEN A.DiffDate <= 56 THEN A.IdTransacao END) AS QtdeUsoProdutoD56
    FROM tb_transacoes AS A
    LEFT JOIN transacao_produto AS B
    ON A.IdTransacao = B.IdTransacao
    LEFT JOIN produtos AS C
    ON B.IdProduto = C.IdProduto
    GROUP BY A.IdCliente, C.DescNomeProduto
),

tb_produtos_mais_usados_rn AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY QtdeUsoProdutoLifeTime DESC) AS RN_LifeTime,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY QtdeUsoProdutoD7 DESC) AS RN_D7,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY QtdeUsoProdutoD14 DESC) AS RN_D14,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY QtdeUsoProdutoD28 DESC) AS RN_D28,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY QtdeUsoProdutoD56 DESC) AS RN_D56
    FROM tb_produtos_mais_usados
),

-- Dias da semana mais ativos (D28)
tb_dias_mais_ativos AS (
    SELECT
        A.IdCliente,
        STRFTIME('%w', A.DtCriacao) AS DiaSemanaNum,
        CASE
            WHEN STRFTIME('%w', A.DtCriacao) = '0' THEN 'Domingo'
            WHEN STRFTIME('%w', A.DtCriacao) = '1' THEN 'Segunda'
            WHEN STRFTIME('%w', A.DtCriacao) = '2' THEN 'Terça'
            WHEN STRFTIME('%w', A.DtCriacao) = '3' THEN 'Quarta'
            WHEN STRFTIME('%w', A.DtCriacao) = '4' THEN 'Quinta'
            WHEN STRFTIME('%w', A.DtCriacao) = '5' THEN 'Sexta'
            WHEN STRFTIME('%w', A.DtCriacao) = '6' THEN 'Sábado'
        END AS DiaSemana,
        COUNT(A.IdTransacao) AS QtdeTransacoesDiaSemana
    FROM tb_transacoes AS A
    WHERE A.DiffDate <= 28
    GROUP BY A.IdCliente, DiaSemanaNum
),

tb_dias_mais_ativos_rn AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY QtdeTransacoesDiaSemana DESC) AS RN_DiaSemana
    FROM tb_dias_mais_ativos
),

-- Período do dia mais ativo (D28)
tb_periodo_dia_mais_ativo AS (
    SELECT
        IdCliente,
        CASE
            WHEN DtHora BETWEEN 6 AND 11 THEN 'Manhã'
            WHEN DtHora BETWEEN 12 AND 17 THEN 'Tarde'
            WHEN DtHora BETWEEN 18 AND 23 THEN 'Noite'
        ELSE 'Madrugada' END AS PeriodoTransacao,
        COUNT(*) AS QtdeTransacaoPeriodo
    FROM tb_transacoes
    WHERE DiffDate <= 28
    GROUP BY 1, 2
),

tb_periodo_dia_mais_ativo_rn AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY QtdeTransacaoPeriodo DESC) AS RN_Periodo
    FROM tb_periodo_dia_mais_ativo
),

tb_final AS (
    SELECT
        A.*,
        B.IdadeCliente,
        C.DescNomeProduto AS ProdutoMaisUsadoLifeTime,
        D.DescNomeProduto AS ProdutoMaisUsadoD7,
        E.DescNomeProduto AS ProdutoMaisUsadoD14,
        F.DescNomeProduto AS ProdutoMaisUsadoD28,
        G.DescNomeProduto AS ProdutoMaisUsadoD56,
        COALESCE(H.DiaSemana, 'N/A') AS DiaSemanaMaisFreqD28,
        COALESCE(I.PeriodoTransacao, 'N/A') AS PeriodoMaisTransacoesD28
    FROM tb_sumario_transacoes AS A

    LEFT JOIN tb_idade_clientes AS B
    ON A.IdCliente = B.IdCliente

    LEFT JOIN tb_produtos_mais_usados_rn AS C
    ON A.IdCliente = C.IdCliente AND C.RN_LifeTime = 1

    LEFT JOIN tb_produtos_mais_usados_rn AS D
    ON A.IdCliente = D.IdCliente AND D.RN_D7 = 1

    LEFT JOIN tb_produtos_mais_usados_rn AS E
    ON A.IdCliente = E.IdCliente AND E.RN_D14 = 1

    LEFT JOIN tb_produtos_mais_usados_rn AS F
    ON A.IdCliente = F.IdCliente AND F.RN_D28 = 1

    LEFT JOIN tb_produtos_mais_usados_rn AS G
    ON A.IdCliente = G.IdCliente AND G.RN_D56 = 1

    LEFT JOIN tb_dias_mais_ativos_rn AS H
    ON A.IdCliente = H.IdCliente AND H.RN_DiaSemana = 1

    LEFT JOIN tb_periodo_dia_mais_ativo_rn AS I
    ON A.IdCliente = I.IdCliente AND I.RN_Periodo = 1
    
)

-- Engajamento em D28 versus Vida
SELECT
    '{date}' AS DataRef,
    *,
    1. * QtdeTransacoesD28 / QtdeTransacoesLifeTime AS EngajamentoD28PorLifeTime
FROM tb_final;

SELECT * FROM feature_store_clientes
ORDER BY IdCliente, DataRef