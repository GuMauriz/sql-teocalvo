-- Dos clientes que começaram SQL no primeiro dia, quantos chegaram ao 5o dia?
SELECT
    COUNT(DISTINCT A.IdCliente) AS QtdeClientes
FROM transacoes AS A
WHERE A.IdCliente IN (
    SELECT IdCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) = '2025-08-25'
)
AND substr(A.DtCriacao, 1, 10) = '2025-08-29';

-- Dentre os clientes de janeiro/2025, quantos assistiram o curso de SQL?
SELECT
    COUNT(DISTINCT A.IdCliente)
FROM clientes AS A
WHERE SUBSTR(DtCriacao, 1, 7) = '2025-01'
AND IdCliente IN (
    SELECT DISTINCT IdCliente
    FROM transacoes
    WHERE substr(DtCriacao, 1, 10) BETWEEN '2025-08-25' AND '2025-08-29'
);