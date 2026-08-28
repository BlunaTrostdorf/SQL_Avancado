---Como analisar Trimestres de verdade (QoQ) 
---Precisa fazer analises temporais e fazer análise linha à linha comparando um dado temporal com outro? a funcao de janela LAG nos ajuda com isso

WITH analise_trimestral AS (
  SELECT
    QUARTER(data) AS trimestre,
    farmacia_id,
    ROUND(SUM(faturamento), 2) AS faturamento_trimestre
  FROM vendas
  GROUP BY QUARTER(data), farmacia_id
),

analise_lag AS (
  SELECT 
    trimestre,
    farmacia_id,
    faturamento_trimestre,
    -- Volta 1 TRIMESTRE para trás
    LAG(faturamento_trimestre, 1) OVER (
      PARTITION BY farmacia_id 
      ORDER BY trimestre ASC
    ) AS faturamento_trimestre_anterior
  FROM analise_trimestral
)

SELECT 
  trimestre,
  farmacia_id,
  faturamento_trimestre,
  faturamento_trimestre_anterior,
  ROUND(
    (faturamento_trimestre - faturamento_trimestre_anterior) 
    / faturamento_trimestre_anterior * 100, 2
  ) AS variacao_perc_trimestral
FROM analise_lag
ORDER BY farmacia_id, trimestre ASC
