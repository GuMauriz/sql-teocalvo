WITH tb_cliente_dia AS (
    SELECT
        DISTINCT IdCliente,
        SUBSTR(DtCriacao, 1, 10) AS DiaCurso,
        COUNT(IdTransacao) AS QtdeTransacoes
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
    GROUP BY 1, 2
),

tb_lag AS (
    SELECT
        *,
        SUM(QtdeTransacoes) OVER (PARTITION BY IdCliente ORDER BY DiaCurso) AS QtdeTransacoesAcum,
        LAG(QtdeTransacoes) OVER (PARTITION BY IdCliente ORDER BY DiaCurso) AS QtdeTransacoesDiaAnterior
    FROM tb_cliente_dia
)

SELECT
    *,
    ROUND(100. * QtdeTransacoes/QtdeTransacoesDiaAnterior, 2) AS PercCrescimento
FROM tb_lag