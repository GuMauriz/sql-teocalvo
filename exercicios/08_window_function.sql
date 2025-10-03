-- Qual a quantidade de transações acumuladas ao longo do tempo?
WITH tb_trans_qtd_anomes AS (
    SELECT
        SUBSTR(DtCriacao, 1, 7) AS AnoMes,
        COUNT(IdTransacao) AS QtdeTransacoes
    FROM transacoes
    GROUP BY 1
    ORDER BY 1
)

SELECT
    AnoMes,
    QtdeTransacoes,
    SUM(QtdeTransacoes) OVER (ORDER BY AnoMes) AS TransacoesAcumuladas
FROM tb_trans_qtd_anomes;

-- Quantidade de usuários cadastrados (abs e acum) ao longo do tempo?
WITH tb_cli_qtd_anomes AS (
    SELECT
        SUBSTR(DtCriacao, 1, 7) AS AnoMes,
        COUNT(idCliente) AS QtdeClientes
    FROM clientes
    GROUP BY 1
    ORDER BY 1
)

SELECT
    AnoMes,
    QtdeClientes,
    SUM(QtdeClientes) OVER (ORDER BY AnoMes) AS ClientesAcumulados
FROM tb_cli_qtd_anomes;

-- Qual o dia da semana mais ativo de cada usuário?
WITH tb_cli_dia_semana AS (
    SELECT
        IdCliente,
        STRFTIME('%w', DtCriacao) AS DiaSemanaNum,
        CASE STRFTIME('%w', DtCriacao)
            WHEN '0' THEN 'Domingo'
            WHEN '1' THEN 'Segunda'
            WHEN '2' THEN 'Terça'
            WHEN '3' THEN 'Quarta'
            WHEN '4' THEN 'Quinta'
            WHEN '5' THEN 'Sexta'
            WHEN '6' THEN 'Sábado'
        END AS DiaSemana,
        COUNT(IdTransacao) AS QtdeTransacoes
    FROM transacoes
    GROUP BY 1, 2
),

tb_cli_dia_semana_rn AS (
    SELECT
        IdCliente,
        DiaSemana,
        QtdeTransacoes,
        ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY QtdeTransacoes DESC, DiaSemanaNum) AS RN
    FROM tb_cli_dia_semana
)

SELECT IdCliente, DiaSemana, QtdeTransacoes
FROM tb_cli_dia_semana_rn
WHERE RN = 1;

-- Saldo de pontos acumulado de cada usuário
WITH tb_cli_pts_anomes AS (
    SELECT
        IdCliente,
        SUBSTR(DtCriacao, 1, 7) AS AnoMes,
        SUM(qtdePontos) AS PontosSomados
    FROM transacoes
    GROUP BY 1, 2
    ORDER BY 1, 2
)

SELECT
    IdCliente,
    AnoMes,
    PontosSomados,
    SUM(PontosSomados) OVER (PARTITION BY IdCliente ORDER BY AnoMes) AS SaldoPontosAcumulados
FROM tb_cli_pts_anomes
ORDER BY 1, 2;