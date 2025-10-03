-- Listar os clientes com total de pontos MAIOR do que 4000 em julho de 2025
SELECT
    IdCliente,
    SUM(QtdePontos) AS totalPontos,
    COUNT(IdTransacao) AS totalTransacoes
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
GROUP BY IdCliente
HAVING SUM(QtdePontos) > 4000
ORDER BY totalPontos DESC