-- Qual categoria tem mais produtos vendidos?
SELECT
    B.DescCategoriaProduto AS Categoria,
    SUM(A.QtdeProduto) AS TotalProdutosVendidos
FROM transacao_produto AS A
LEFT JOIN produtos AS B
ON A.idProduto = B.idProduto
GROUP BY 1
ORDER BY 2 DESC;

-- Em 2024, quantas transações de Lovers tivemos?
SELECT
    C.DescCategoriaProduto AS Categoria,
    COUNT(DISTINCT A.idTransacao) AS TotalTransacoes
FROM transacoes AS A
LEFT JOIN transacao_produto AS B
ON A.idTransacao = B.idTransacao
LEFT JOIN produtos AS C
ON B.idProduto = C.idProduto
WHERE substr(A.DtCriacao, 1, 4) = '2024'
GROUP BY 1
ORDER BY 2 DESC;

-- Qual mês tivemos mais lista de presença assinada?
SELECT
    CASE
        WHEN substr(A.DtCriacao, 6, 2) = '01' THEN 'Janeiro'
        WHEN substr(A.DtCriacao, 6, 2) = '02' THEN 'Fevereiro'
        WHEN substr(A.DtCriacao, 6, 2) = '03' THEN 'Março'
        WHEN substr(A.DtCriacao, 6, 2) = '04' THEN 'Abril'
        WHEN substr(A.DtCriacao, 6, 2) = '05' THEN 'Maio'
        WHEN substr(A.DtCriacao, 6, 2) = '06' THEN 'Junho'
        WHEN substr(A.DtCriacao, 6, 2) = '07' THEN 'Julho'
        WHEN substr(A.DtCriacao, 6, 2) = '08' THEN 'Agosto'
        WHEN substr(A.DtCriacao, 6, 2) = '09' THEN 'Setembro'
        WHEN substr(A.DtCriacao, 6, 2) = '10' THEN 'Outubro'
        WHEN substr(A.DtCriacao, 6, 2) = '11' THEN 'Novembro'
        WHEN substr(A.DtCriacao, 6, 2) = '12' THEN 'Dezembro'
    END AS MesNome,
    COUNT(DISTINCT A.idTransacao) AS TotalListasPresenca
FROM transacoes AS A
LEFT JOIN transacao_produto AS B
ON A.idTransacao = B.idTransacao
LEFT JOIN produtos AS C
ON B.idProduto = C.idProduto
WHERE C.DescNomeProduto LIKE '%Lista de%'
GROUP BY MesNome
ORDER BY TotalListasPresenca DESC;

-- Qual o total de pontos trocados no Stream Elements em Junho de 2025?
SELECT
    ABS(SUM(A.QtdePontos)) AS TotalPontosTrocados
FROM transacoes AS A
LEFT JOIN transacao_produto AS B
ON A.idTransacao = B.idTransacao
LEFT JOIN produtos AS C
ON B.idProduto = C.idProduto
WHERE C.DescCategoriaProduto = 'streamelements'
AND substr(A.DtCriacao, 1, 7) = '2025-06';