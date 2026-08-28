# SQL-avancado
Repositório dedicado à análises com SQL avançado com uso de agregações, joins e funções de janela para trazer insights através dos dados.


# Análise de Representatividade por Categoria (Share %)

## 📌 Objetivo
Calcular o percentual de representatividade (`share_perc`) de cada produto em relação ao faturamento total da sua respectiva categoria usando **Window Functions**.

##  Tecnologias
- SQL (DuckDB / MotherDuck)

##  Lógica Aplicada
1. **CTE 1 (`analise`)**: Agrupa e soma o faturamento por `categoria` e `produto`.
2. **CTE 2 (`analise_2`)**: Aplica `SUM(...) OVER(PARTITION BY categoria)` para calcular o total acumulado da categoria sem colapsar as linhas.
3. **Consulta Final**: Calcula o percentual (`(faturamento_total / faturamento_produto) * 100`).

##  Query SQL
```sql
WITH analise AS (
  ...
)
SELECT * FROM analise_2;
```


