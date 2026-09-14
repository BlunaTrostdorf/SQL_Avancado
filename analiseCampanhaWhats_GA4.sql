
-- exemplo de codigo de como fazer uma analise limpa para mensurar uma campanha com regra de atraibuição de 7 dias após um disparo de mensagem CRM
-- Num BI poderiamos ver todo funil desde msg até a conversão
-- ferramenta de analise utiliza : MotherDuck


------------------------------------------------
WITH WhatsTratado AS (
    -- Filtra apenas quem clicou no link da oferta no WhatsApp
    SELECT 
        id_cliente,
        MIN(data_hora) AS data_clique_whats
    FROM base_whatsapp_tratada
    WHERE disparo_campanha = 'Oferta_Cartao_Nov'
      AND evento_whatsapp = 'clique_link'
    GROUP BY id_cliente
),

NavegacaoGA4 AS (
    -- Pega quem esteve no site vindo do WhatsApp no GA4
    SELECT DISTINCT
        user_id, -- ID do cliente no GA4
        MAX(CASE WHEN event_name = 'proposta_concluida' THEN 1 ELSE 0 END) AS converteu_site
    FROM `seu-projeto.ga4.events_*`
    WHERE (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source') = 'whatsapp'
    GROUP BY user_id
)

-- Cruzamento Final: Tabela de WhatsApp com GA4
SELECT 
    w.id_cliente,
    w.data_clique_whats,
    COALESCE(g.converteu_site, 0) AS converteu_site,
    CASE 
        WHEN g.converteu_site = 1 THEN 'Convertido'
        ELSE 'Abandonou no Site'
    END AS status_jornada
FROM WhatsTratado w
LEFT JOIN NavegacaoGA4 g
    ON w.id_cliente = g.user_id;

