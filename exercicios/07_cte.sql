-- Quem iniciou o curso no primeiro dia, em média assistiu quantas aulas?

WITH tb_primeiro_dia AS (
    SELECT
        DISTINCT IdCliente
    FROM transacoes
    WHERE SUBSTR(DtCriacao, 1, 10) = '2025-08-25'
),

tb_dias AS (
    SELECT DISTINCT
        IdCliente,
        SUBSTR(DtCriacao, 1, 10) AS DataAula
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
),

tb_final AS (
    SELECT
        A.IdCliente,
        COUNT(B.DataAula) AS QtdeDiasComAula
    FROM tb_primeiro_dia AS A
    LEFT JOIN tb_dias AS B
    ON A.IdCliente = B.IdCliente
    GROUP BY 1
)

SELECT AVG(QtdeDiasComAula) AS MediaDiasComAula
FROM tb_final;

-- Qual o dia com maior engajamento de
-- cada aluno que iniciou o curso no dia 01?

WITH tb_primeiro_dia AS (
    SELECT
        DISTINCT IdCliente
    FROM transacoes
    WHERE SUBSTR(DtCriacao, 1, 10) = '2025-08-25'
),

tb_dias AS (
    SELECT DISTINCT
        IdCliente,
        SUBSTR(DtCriacao, 1, 10) AS DataAula,
        COUNT(IdTransacao) AS QtdeTransacoes
    FROM transacoes
    WHERE DtCriacao >= '2025-08-25'
    AND DtCriacao < '2025-08-30'
    GROUP BY 1, 2
),

tb_final AS (
    SELECT
        A.IdCliente,
        B.DataAula,
        B.QtdeTransacoes
    FROM tb_primeiro_dia AS A
    LEFT JOIN tb_dias AS B
    ON A.IdCliente = B.IdCliente
    GROUP BY 1, 2
)

SELECT *
FROM tb_final
WHERE (IdCliente, QtdeTransacoes) IN (
    SELECT
        IdCliente,
        MAX(QtdeTransacoes)
        FROM tb_final
        GROUP BY 1
)
GROUP BY 1