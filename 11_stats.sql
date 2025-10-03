SELECT AVG(QtdePontos) AS mediaPontos FROM clientes;

SELECT
    ROUND(AVG(QtdePontos), 2) AS mediaPontos,
    MIN(QtdePontos) AS minPontos,
    MAX(QtdePontos) AS maxPontos
FROM clientes;