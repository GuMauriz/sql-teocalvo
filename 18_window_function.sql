WITH tb_sumario_dias AS (
    SELECT
        SUBSTR(DtCriacao, 1, 10) AS DiaCurso,
        COUNT(DISTINCT IdTransacao) AS QtdeTransacoes
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
    GROUP BY DiaCurso
)

SELECT
    *,
    SUM(QtdeTransacoes) OVER (ORDER BY DiaCurso) AS QtdeTransacoesAcum
FROM tb_sumario_dias;