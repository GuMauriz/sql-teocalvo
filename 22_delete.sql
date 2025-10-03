-- Deleta todos os registros de domingos
DELETE FROM relatorio_diario
WHERE STRFTIME('%w', DiaAnoMes) = '0';

SELECT * FROM relatorio_diario;