-- Mostrar registros distintos em uma ou mais coluna
SELECT DISTINCT flTwitch, flEmail FROM clientes;
-- Contar registros distintos em uma coluna. Não pode ser mais do que uma.
SELECT COUNT(DISTINCT flTwitch) FROM clientes;

-- Mostrar registros de um mês específico
SELECT * FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY DtCriacao DESC;
-- Contar registros de um mês específico
SELECT COUNT(*) FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
ORDER BY DtCriacao DESC;
-- Contar registros totais e registros distintos de um mês específico
SELECT
    COUNT(*) as QtdTransacoes,
    COUNT(DISTINCT IdCliente) as QtdClientes
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'