-- Mostrar todas as transações de produtos da categoria 'lover'

-- Verificar o IdProduto dos produtos da categoria 'lover'
SELECT IdProduto
FROM produtos
WHERE DescCategoriaProduto LIKE '%lover%';

-- O resultado gerado é uma tabela de n registros, com uma coluna (IdProduto).
-- Como usar essa tabela para filtrar as transações que contém esses produtos?
-- Uma forma de fazer isso é usando subquery (subconsulta).

SELECT *
FROM transacao_produto
WHERE IdProduto IN (
    SELECT IdProduto
    FROM produtos
    WHERE DescCategoriaProduto LIKE '%lover%'
);

-- Também é possível fazer a subquery na cláusula FROM
SELECT *
FROM (
    SELECT *
    FROM transacoes
    WHERE DtCriacao >= '2025-01-01'
)
WHERE DtCriacao < '2025-02-01';