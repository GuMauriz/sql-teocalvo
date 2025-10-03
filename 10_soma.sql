-- Contagem de pontos FINAL em julho de 2025.
SELECT SUM(QtdePontos) FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01';

-- Contagem de pontos GANHOS em julho de 2025.
SELECT SUM(QtdePontos) FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01'
AND QtdePontos > 0;

--  Contagem e soma de pontos GANHOS e PERDIDOS em julho de 2025.
SELECT
    SUM(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS PontosGanhos,
    COUNT(CASE WHEN QtdePontos > 0 THEN 1 ELSE NULL END) AS TransacoesGanhas,
    SUM(CASE WHEN QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS PontosPerdidos,
    COUNT(CASE WHEN QtdePontos < 0 THEN 1 ELSE NULL END) AS TransacoesPerdidas
FROM transacoes
WHERE DtCriacao >= '2025-07-01'
AND DtCriacao < '2025-08-01';