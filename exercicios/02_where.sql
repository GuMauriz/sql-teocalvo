-- Lista de transações com apenas 1 ponto;

SELECT IdTransacao FROM transacoes
WHERE qtdePontos = 1;

-- Lista de pedidos realizados no fim de semana;

SELECT IdTransacao,
        DtCriacao,
        strftime('%w', datetime(substr(DtCriacao, 1, 10))) AS DiaSemana
FROM transacoes
WHERE DiaSemana IN ('0', '6');

-- Lista de clientes com 0 (zero) pontos;

SELECT idCliente, QtdePontos FROM clientes
WHERE QtdePontos = 0;

-- Lista de clientes com 100 a 200 pontos (inclusive ambos);

SELECT idCliente, QtdePontos FROM clientes
WHERE QtdePontos BETWEEN 100 AND 200;

-- Lista de produtos com nome que começa com “Venda de”;

SELECT IdProduto, DescNomeProduto FROM produtos
WHERE DescNomeProduto LIKE 'Venda de%';

-- Lista de produtos com nome que termina com “Lover”;

SELECT IdProduto, DescNomeProduto FROM produtos
WHERE DescNomeProduto LIKE '%Lover';

-- Lista de produtos que são DIFERENTES de “chapéu”;

SELECT IdProduto, DescNomeProduto, DescCategoriaProduto FROM produtos
WHERE DescCategoriaProduto NOT LIKE '%chapeu%';

-- Lista de transações com o produto “Resgatar Ponei”;

SELECT * FROM produtos
WHERE DescNomeProduto = 'Resgatar Ponei';

SELECT * FROM transacao_produto
WHERE IdProduto = 15;

-- Listar todas as transações adicionando uma coluna nova sinalizando
-- “alto”, “médio” e “baixo” para o valor dos pontos [<10 ; <500; >=500]

SELECT IdTransacao,
        QtdePontos,
        CASE
            WHEN QtdePontos < 10 THEN 'baixo'
            WHEN QtdePontos < 500 THEN 'medio'
            WHEN QtdePontos >= 500 THEN 'alto'
        END AS categoria_pontos
FROM transacoes
