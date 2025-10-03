-- CTE: COMMON TABLE EXPRESSION
-- Permite criar tabelas temporárias dentro de uma query.
--  É necessário rodar a query inteira, não dá para rodar só a CTE.

WITH tabela_comeco AS (
    SELECT
        DISTINCT IdCliente
    FROM transacoes
    WHERE SUBSTR(DtCriacao, 1, 10) = '2025-08-25'
),

tabela_fim AS (
    SELECT
        DISTINCT IdCliente
    FROM transacoes
    WHERE SUBSTR(DtCriacao, 1, 10) = '2025-08-29'
),

tabela_join AS (
    SELECT
        A.IdCliente AS IdClienteComeco,
        B.IdCliente AS IdClienteFim
    FROM tabela_comeco AS A
    LEFT JOIN tabela_fim AS B
    ON A.IdCliente = B.IdCliente
)

SELECT
    COUNT(DISTINCT IdClienteComeco),
    COUNT(DISTINCT IdClienteFim),
    1. * COUNT(DISTINCT IdClienteFim) / COUNT(DISTINCT IdClienteComeco) AS TaxaRetencao
FROM tabela_join;