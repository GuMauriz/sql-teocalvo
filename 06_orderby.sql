-- Quem tem mais pontos
SELECT * FROM clientes ORDER BY QtdePontos DESC LIMIT 10;

-- Mais antigo para o mais novo, além de quem tem mais pontos
SELECT * FROM clientes ORDER BY DtCriacao, QtdePontos DESC LIMIT 10;

-- Mais antigo para o mais novo, além de quem tem mais pontos e vem da twitch
SELECT *
FROM clientes
WHERE flTwitch = 1
ORDER BY DtCriacao, QtdePontos DESC LIMIT 10;