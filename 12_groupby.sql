-- Contar quantos produtos existem em cada transação
SELECT 
    IdProduto,
    COUNT(*)
FROM transacao_produto
GROUP BY IdProduto;

-- Listar os 10 clientes com maior total de pontos acumulados em julho de 2025
SELECT
    IdCliente,
    SUM(QtdePontos) AS totalPontos,
    COUNT(IdTransacao) AS totalTransacoes
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
GROUP BY IdCliente
ORDER BY totalPontos DESC
LIMIT 10;