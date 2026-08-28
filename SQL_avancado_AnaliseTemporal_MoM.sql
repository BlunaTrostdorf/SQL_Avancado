----Análise temporam observando mês sobre mês 
--Importante em cenarios de comparação e observar variação percentual de queda ou crescimento de faturamento


WITH analise_trimestral AS (
  SELECT
    MONTH(data) AS mes,
    farmacia_id,
    ROUND(SUM(faturamento), 2) AS faturamento_mes
  FROM vendas
  GROUP BY MONTH(data), farmacia_id
),

analise_lag AS (
  SELECT 
    mes,
    farmacia_id,
    faturamento_mes,
    -- Volta 1 TRIMESTRE para trás
    LAG(faturamento_mes, 1) OVER (
      PARTITION BY farmacia_id 
      ORDER BY mes ASC
    ) AS faturamento_mes_anterior
  FROM analise_trimestral
)

SELECT 
  mes,  
  farmacia_id,
  faturamento_mes,
  faturamento_mes_anterior,
  ROUND(
    (faturamento_mes - faturamento_mes_anterior) 
    / faturamento_mes_anterior * 100, 2
  ) AS variacao_perc_mes
FROM analise_lag
ORDER BY farmacia_id, mes ASC
