SELECT
    A.IdTransacao,
    A.IdProduto,
    B.DescNomeProduto,
    A.QtdeProduto,
    A.vlProduto
FROM transacao_produto AS A
LEFT JOIN produtos AS B
ON A.IdProduto = B.IdProduto;