SELECT idCliente,
        QtdePontos,
        QtdePontos * 1.05 AS PontoMais5PorCento,
        datetime (substr(DtCriacao, 1, 10)) AS DataCriacaoFix,
        strftime('%w', datetime (substr(DtCriacao, 1, 10))) AS DiaSemana
FROM clientes;