-- EXCLUIR TABELA CASO JA EXISTA
DROP TABLE IF EXISTS relatorio_diario;
-- CRIAR TABELA CASO NAO EXISTA
CREATE TABLE IF NOT EXISTS relatorio_diario AS 
    -- Saldo de pontos acumulados ao longo dos dias
    WITH tb_cli_pts_anomes AS (
        SELECT
            SUBSTR(DtCriacao, 1, 10) AS DiaAnoMes,
            SUM(qtdePontos) AS PontosSomados
        FROM transacoes
        GROUP BY 1
        ORDER BY 1
    )
    
    SELECT
        DiaAnoMes,
        PontosSomados,
        SUM(PontosSomados) OVER (PARTITION BY DiaAnoMes ORDER BY DiaAnoMes) AS SaldoPontosAcumulados
    FROM tb_cli_pts_anomes
    ORDER BY 1, 2;

SELECT * FROM relatorio_diario;

-- EXCLUIR TODOS OS REGISTROS DA TABELA, MAS MANTER A ESTRUTURA
DELETE FROM relatorio_diario;
-- VERIFICAR A ESTRUTURA DA TABELA
.schema relatorio_diario