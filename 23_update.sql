-- Diminui 1000 pontos acumulados em todos os sábados
UPDATE relatorio_diario
SET SaldoPontosAcumulados = SaldoPontosAcumulados - 1000
WHERE STRFTIME('%w', DiaAnoMes) = '6';

SELECT * FROM relatorio_diario;