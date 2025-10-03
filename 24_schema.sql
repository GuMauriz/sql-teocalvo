DROP TABLE IF EXISTS tb_cli_ultimo_dia;

CREATE TABLE IF NOT EXISTS tb_cli_ultimo_dia (
    IdCliente varchar(255) PRIMARY KEY,
    QtdePontos INT
);

INSERT INTO tb_cli_ultimo_dia
SELECT 
    IdCliente,
    SUM(qtdePontos) AS QtdePontos
FROM transacoes
WHERE SUBSTR(DtCriacao, 1, 10) =
    (SELECT MAX(SUBSTR(DtCriacao, 1, 10)) FROM transacoes)
GROUP BY 1;

SELECT * FROM tb_cli_ultimo_dia;