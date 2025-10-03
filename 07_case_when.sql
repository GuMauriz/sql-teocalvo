-- Intervalos:
-- De 0 a 500 -> Ponei
-- 500 a 1000 -> Ponei Premium
-- 1001 a 5000 -> Mago Aprendiz
-- 5000 a 10000 -> Mago Mestre
-- Mais de 10000 -> Mago Supremo

SELECT idCliente,
        qtdePontos,
        CASE
            WHEN qtdePontos BETWEEN 0 AND 500 THEN 'Ponei'
            WHEN qtdePontos BETWEEN 501 AND 1000 THEN 'Ponei Premium'
            WHEN qtdePontos BETWEEN 1001 AND 5000 THEN 'Mago Aprendiz'
            WHEN qtdePontos BETWEEN 5001 AND 10000 THEN 'Mago Mestre'
            WHEN qtdePontos > 10000 THEN 'Mago Supremo'
            ELSE 'Sem Categoria'
        END AS categoria
FROM clientes LIMIT 1000;