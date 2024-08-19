-- Questão 1: Quantos chamados foram abertos no dia 01/04/2023?
SELECT COUNT(*) AS chamados_abertos
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01'
-- Resposta : 1756

-- Questão 2: Qual o tipo de chamado que teve mais teve chamados abertos no dia 01/04/2023?
SELECT tipo, COUNT(*) AS qtd_chamados
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01'
GROUP BY tipo
ORDER BY qtd_chamados DESC
LIMIT 1
-- Resposta: Estacionamento irregular, com 366 ocorrências