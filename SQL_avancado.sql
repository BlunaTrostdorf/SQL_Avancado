WITH analise AS (
  SELECT
    p.categoria,
    p.produto,
    ROUND(SUM(v.faturamento), 2) AS faturamento_total
  FROM vendas v 
  INNER JOIN produtos p 
    ON v.produto_id = p.produto_id
  GROUP BY 1, 2
),

analise_2 AS (
  SELECT
    categoria,
    produto,
    faturamento_total,
    ROUND(SUM(faturamento_total) OVER (PARTITION BY categoria), 2) AS faturamento_produto
  FROM analise
)

SELECT 
  *,
  ROUND((faturamento_total / faturamento_produto * 100), 2) AS share_perc
FROM analise_2;
