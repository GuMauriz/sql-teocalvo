-- Quais são os cinco clientes que mais perderam pontos por Lover?
SELECT
    A.IdCliente,
    SUM(A.QtdePontos) AS TotalPontosPerdidos
FROM transacoes AS A
LEFT JOIN transacao_produto AS B
ON A.IdTransacao = B.IdTransacao
LEFT JOIN produtos AS C
ON B.IdProduto = C.IdProduto
WHERE C.DescCategoriaProduto LIKE '%lover%'
GROUP BY 1
ORDER BY 2 ASC
LIMIT 5;

-- Quais clientes assinaram a lista de presença no dia 2025/08/25?
SELECT
    A.IdCliente
FROM transacoes AS A
LEFT JOIN transacao_produto AS B
ON A.IdTransacao = B.IdTransacao
LEFT JOIN produtos AS C
ON B.IdProduto = C.IdProduto
WHERE substr(A.DtCriacao, 1, 10) = '2025-08-25'
AND C.DescNomeProduto LIKE '%Lista de%';

-- Do início ao fim do nosso curso (2025/08/25 a 2025/08/29),
-- quantos clientes assinaram a lista de presença?
SELECT
    COUNT(DISTINCT A.IdCliente)
FROM transacoes AS A
LEFT JOIN transacao_produto AS B
ON A.IdTransacao = B.IdTransacao
LEFT JOIN produtos AS C
ON B.IdProduto = C.IdProduto
WHERE A.DtCriacao >= '2025-08-25'
AND A.DtCriacao <= '2025-08-30'
AND C.DescNomeProduto LIKE '%Lista de%';

-- Clientes mais antigos, tem mais frequência de transação?
SELECT
    A.IdCliente,
    MAX(CAST(JULIANDAY('NOW') - JULIANDAY(SUBSTR(A.DtCriacao, 1, 19)) AS INT)) AS DiasDesdeCadastro,
    COUNT(B.IdTransacao) AS QtdeTransacoes
FROM clientes AS A
LEFT JOIN transacoes AS B
ON A.IdCliente = B.IdCliente
GROUP BY 1
ORDER BY 3 DESC

-- Quantidade de transações Acumuladas ao longo do tempo?


-- Quantidade de usuários cadastrados (absoluto e acumulado)
-- ao longo do tempo?


-- Qual o dia da semana mais ativo de cada usuário?


-- Saldo de pontos acumulado de cada usuário


-- Dados para referência
SELECT * FROM produtos;
SELECT * FROM transacoes;
SELECT * FROM transacao_produto;