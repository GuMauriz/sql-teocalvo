-- Quantos clientes tem email cadastrado?
SELECT
    flEmail,
    COUNT(flEmail) AS total
FROM clientes
GROUP BY flEmail
HAVING flEmail > 0;

-- Qual cliente juntou mais pontos positivos em 2025-05?
SELECT
    idCliente,
    CASE
        WHEN QtdePontos > 0 THEN QtdePontos
        ELSE 0
    END AS pontos_positivos
FROM clientes
WHERE DtCriacao >= '2025-05-01'
AND DtCriacao < '2025-06-01'
GROUP BY idCliente
ORDER BY pontos_positivos DESC
LIMIT 1;

SELECT
    idCliente,
    SUM(QtdePontos) AS total_pontos
FROM clientes
WHERE DtCriacao >= '2025-05-01'
AND DtCriacao < '2025-06-01'
AND QtdePontos > 0
GROUP BY idCliente
ORDER BY total_pontos DESC
LIMIT 1;

-- Qual cliente fez mais transações no ano de 2024?
SELECT
    IdCliente,
    COUNT(IdTransacao) AS total_transacoes,
    MIN(DtCriacao) AS primeira_transacao,
    MAX(DtCriacao) AS ultima_transacao
FROM transacoes
WHERE DtCriacao >= '2024-01-01'
AND DtCriacao < '2025-01-01'
GROUP BY IdCliente
ORDER BY total_transacoes DESC
LIMIT 1;

-- Quantos produtos são de rpg?
SELECT
    DescCategoriaProduto,
    COUNT(IdProduto) AS total
FROM produtos
WHERE DescCategoriaProduto = 'rpg'
GROUP BY DescCategoriaProduto;

-- Qual o valor médio de pontos positivos por dia?
SELECT
    COUNT(substr(DtCriacao, 1, 10)) AS total_dias,
    COUNT(DISTINCT substr(DtCriacao, 1, 10)) AS dias_distintos,
    SUM(QtdePontos) * 1.0 / COUNT(DISTINCT substr(DtCriacao, 1, 10)) AS media_pontos_dia
FROM transacoes
WHERE QtdePontos > 0;

-- adicional: Qual o valor médio de pontos positivos por dia de semana?
SELECT
    CASE
        WHEN strftime('%w', DtCriacao) = '0' THEN 'Domingo'
        WHEN strftime('%w', DtCriacao) = '1' THEN 'Segunda-feira'
        WHEN strftime('%w', DtCriacao) = '2' THEN 'Terça-feira'
        WHEN strftime('%w', DtCriacao) = '3' THEN 'Quarta-feira'
        WHEN strftime('%w', DtCriacao) = '4' THEN 'Quinta-feira'
        WHEN strftime('%w', DtCriacao) = '5' THEN 'Sexta-feira'
        WHEN strftime('%w', DtCriacao) = '6' THEN 'Sábado'
    END AS dia_semana,
    AVG(QtdePontos) AS media_pontos
FROM transacoes
WHERE QtdePontos > 0
GROUP BY dia_semana
ORDER BY strftime('%w', DtCriacao);

-- Qual dia da semana quem mais pedidos em 2025?
SELECT
    CASE
        WHEN strftime('%w', DtCriacao) = '0' THEN 'Domingo'
        WHEN strftime('%w', DtCriacao) = '1' THEN 'Segunda-feira'
        WHEN strftime('%w', DtCriacao) = '2' THEN 'Terça-feira'
        WHEN strftime('%w', DtCriacao) = '3' THEN 'Quarta-feira'
        WHEN strftime('%w', DtCriacao) = '4' THEN 'Quinta-feira'
        WHEN strftime('%w', DtCriacao) = '5' THEN 'Sexta-feira'
        WHEN strftime('%w', DtCriacao) = '6' THEN 'Sábado'
    END AS dia_semana,
    COUNT(IdTransacao) AS qtdTransacoes
FROM transacoes
WHERE DtCriacao >= '2025-01-01'
AND DtCriacao < '2026-01-01'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Qual o produto mais transacionado?
SELECT
    IdProduto,
    COUNT(idTransacaoProduto) AS total_transacoes
FROM transacao_produto
GROUP BY IdProduto
ORDER BY total_transacoes DESC
LIMIT 1;

-- Qual o produto com mais pontos transacionados?
SELECT
    IdProduto,
    SUM(vlProduto) AS total_pontos
FROM transacao_produto
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;