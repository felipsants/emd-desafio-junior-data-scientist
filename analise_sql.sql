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

-- Questão 3: Quais os nomes dos 3 bairros que mais tiveram chamados abertos nesse dia?
SELECT id_bairro, COUNT(*) AS qtd_chamados_bairro
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01'
GROUP BY id_bairro
ORDER BY qtd_chamados_bairro DESC
LIMIT 4;

SELECT *
FROM `datario.dados_mestres.bairro`
WHERE id_bairro IN ('144', '33','128')
/*
Resposta: Nesta questão, eu filtrei os 3 bairros com mais chamados, porém o 3º bairro não havia
id de identificação, dessa forma eu desconsiderei o 3º colocado e fui para o 4º bairro com mais
ocorrências.
    1º : Campo Grande, ID 144 - Chamados : 113
    2º : Tijuca, ID 33 - Chamados : 89
    3º : Barra da Tijuca, ID 128 - Chamados : 59
    3º : NULL - Chamados : 73 ( Provavelmente, são os chamados que não tem ligação com um lugar fisico.)
*/

-- Questão 4: Qual o nome da subprefeitura com mais chamados abertos nesse dia?
SELECT b.subprefeitura, COUNT(c.id_bairro) AS qtd_chamados_subprefeitura
FROM datario.adm_central_atendimento_1746.chamado c
JOIN datario.dados_mestres.bairro b
ON c.id_bairro = b.id_bairro
WHERE DATE(c.data_inicio) = '2023-04-01'
GROUP BY b.subprefeitura
ORDER BY qtd_chamados_subprefeitura DESC
LIMIT 1;
/*
Resposta: Subprefeitura = Zona Norte, com 510 chamados.

Nessa questão eu decidi usar alias pois estou trabalhando com duas fontes de dados
que tem a mesma coluna id_bairro, assim facilita a leitura.
*/

-- Questão 5: Existe algum chamado aberto nesse dia que não foi associado a um bairro ou subprefeitura na tabela de bairros?Se sim, por que isso acontece?
SELECT *
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) = '2023-04-01' 
  AND id_bairro IS NULL
LIMIT 50

/* Resposta: 
    Sim, existe. Isso ocorre nas chamadas que são relacionadas ao transporte público, no caso
    ônibus, que não tem ligação com um lugar fisico, que no nosso caso de interesse seria um bairro.
*/

-- Questão 6: Quantos chamados com o subtipo "Perturbação do sossego" foram abertos desde 01/01/2022 até 31/12/2023 (incluindo extremidades)?
SELECT subtipo, COUNT(*) AS qtd_chamados_pertubacao
FROM `datario.adm_central_atendimento_1746.chamado`
WHERE DATE(data_inicio) BETWEEN '2022-01-01' AND '2023-12-31'
  AND subtipo = 'Perturbação do sossego'
GROUP BY subtipo
ORDER BY qtd_chamados_pertubacao DESC
-- Resposta: Foram realizados 42830 chamados neste intervalo de datas com o subtipo Perturbação do sossego.

-- Questão 7:Selecione os chamados com esse subtipo que foram abertos durante os eventos contidos na tabela de eventos (Reveillon, Carnaval e Rock in Rio).
SELECT *
FROM `datario.adm_central_atendimento_1746.chamado` c
JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` e
ON DATE(c.data_inicio) = DATE(e.data_inicial)
WHERE c.subtipo = 'Perturbação do sossego'
  AND e.taxa_ocupacao IN (0.9554, 0.9251, 0.9451, 0.8184)
ORDER BY e.data_inicial ASC
/*
    Resposta: Utilizei o taxa_ocupacao como paramêtro para localizar o eventos
    pois existia eventos com o mesmo nome e isso iria me trazer problemas, por isso
    decidi utilizar o taxa_ocupação.
*/
