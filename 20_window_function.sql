WITH tb_cliente_dia AS (
    SELECT DISTINCT 
        IdCliente,
        SUBSTR(DtCriacao, 1, 10) AS DtDia
    FROM transacoes
    WHERE SUBSTR(DtCriacao, 1, 4) = '2025'
),

tb_cliente_dia_diff AS (
    SELECT
        *,
        LAG(DtDia) OVER (PARTITION BY IdCliente ORDER BY DtDia) AS DiaAnterior,
        JULIANDAY(DtDia) - JULIANDAY(LAG(DtDia) OVER (PARTITION BY IdCliente ORDER BY DtDia)) AS DiasEntreTransacoes
    FROM tb_cliente_dia
),

tb_media_dia AS (
    SELECT
        IdCliente,
        AVG(DiasEntreTransacoes) AS MediaDiasEntreTransacoes
    FROM tb_cliente_dia_diff
    WHERE DiaAnterior IS NOT NULL
    GROUP BY IdCliente
)

SELECT AVG(MediaDiasEntreTransacoes) AS MediaGeralDiasEntreTransacoes
FROM tb_media_dia;