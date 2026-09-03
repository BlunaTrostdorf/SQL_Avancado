
-- exemplo de codigo de como fazer uma analise limpa para mensurar uma campanha com regra de atraibuição de 7 dias após um disparo de mensagem CRM
-- Num BI poderiamos ver todo funil desde msg até a conversão
-- ferramenta de analise utiliza : MotherDuck

CREATE OR REPLACE VIEW base_consolidada as
WITH base_whats as (
SELECT
  cliente_id,
  event_timestamp,
  DATE(event_timestamp) AS data_whats,
  
  -- Flags individuais para cada evento
  CASE WHEN status_sent = 'sent' THEN 1 ELSE 0 END AS msg_enviada,
  CASE WHEN status_delivered = 'delivered' THEN 1 ELSE 0 END AS msg_entregue
  
 
FROM my_db.main.base_whatsapp_jornada
),

base_resumo_whats as (
SELECT
  cliente_id,
  data_whats,
  SUM(msg_enviada) AS qnt_msg_enviada,
  SUM(msg_entregue)AS qnt_msg_entregue
  
  from base_whats
  GROUP BY cliente_id,data_whats

),

base_ga4 AS (
    SELECT
        cliente_id,
        DATE(event_timestamp) AS data_ga4,
        produto,
        

        COUNT(*) AS qnt_eventos,

        COUNT(
            CASE WHEN event_name = 'app_open' THEN 1 END
        ) AS abertura_app,

        COUNT(
            CASE WHEN event_name = 'simulacao' THEN 1 END
        ) AS simulacoes,

        COUNT(
            CASE WHEN event_name = 'contratacao' THEN 1 END
        ) AS contratacoes

    FROM my_db.main.base_ga_jornada

    WHERE produto = 'Imobiliário'

    GROUP BY
        cliente_id,
        DATE(event_timestamp),
        produto
        
),

base_consolidada as (
SELECT
wa.cliente_id,
wa.data_whats,
wa.qnt_msg_enviada,
wa.qnt_msg_entregue,
ga.data_ga4,
ga.produto,
ga.qnt_eventos,
ga.abertura_app,
ga.simulacoes,
ga.contratacoes
FROM base_resumo_whats wa 
left join base_ga4 ga 
on wa.cliente_id = ga.cliente_id
AND ga.data_ga4 BETWEEN wa.data_whats
                    AND DATE_ADD(wa.data_whats, INTERVAL 7 DAY)

)
select * from base_consolidada

