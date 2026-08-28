
--Aqui mostro a diferença principal entre os rankings de cada funcao de janela (Row number, Dense_rank, Rank )
--Importante o uso em cenários onde precisamos ver o ranking de um produto ou posição usando metricas de agregação como sum, avg)

WITH faturamento_produtos AS (
  SELECT
    p.categoria,
    p.produto,
    ROUND(SUM(v.faturamento), 2) AS total_faturado
  FROM vendas v
  INNER JOIN produtos p ON v.produto_id = p.produto_id
  GROUP BY p.categoria, p.produto
)

SELECT
  categoria,
  produto,
  total_faturado,
  ROW_NUMBER() OVER (PARTITION BY categoria ORDER BY total_faturado DESC) AS row_num,
  RANK()       OVER (PARTITION BY categoria ORDER BY total_faturado DESC) AS rnk,
  DENSE_RANK() OVER (PARTITION BY categoria ORDER BY total_faturado DESC) AS dense_rnk,
  PERCENT_RANK() OVER (PARTITION BY categoria ORDER BY total_faturado DESC) AS percent_rnk
FROM faturamento_produtos
ORDER BY categoria, total_faturado DESC;
