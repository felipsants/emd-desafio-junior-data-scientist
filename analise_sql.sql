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
id de identificação do bairro, dessa forma eu desconsiderei o 3º colocado e fui para o 4º bairro com mais
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
LIMIT 100

/* Resposta: 
    Sim, existe. Isso ocorre nas chamadas que são relacionadas ao transporte público, atendimento ao publico, defesa do consumidor,
    alvára, que não tem ligação com um lugar fisico, que no nosso caso de interesse seria um bairro.
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

-- Questão 8: Quantos chamados desse subtipo foram abertos em cada evento?
SELECT c.evento, c.taxa_ocupacao,c.data_inicial, c.data_final, COUNT(*) AS qtd_chamados_eventos
FROM datario.adm_central_atendimento_1746.chamado b
JOIN datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos c
ON DATE(b.data_inicio) BETWEEN DATE(c.data_inicial) AND DATE(c.data_final)
WHERE b.subtipo = 'Perturbação do sossego'
  AND c.taxa_ocupacao IN (0.9554, 0.9251, 0.9451, 0.8184)
GROUP BY c.evento, c.taxa_ocupacao,c.data_inicial, c.data_final
ORDER BY qtd_chamados_eventos DESC
/*
    Resposta:
        Rock In Rio ( 08-09-2022 ) : 468 Chamados
        Rock In Rio ( 02-09-2022 ) : 366 Chamados
        Carnaval ( 18-02-2023 ) : 241 Chamados
        Reveillon ( 30-12-2022 ) : 139 Chamados

    Eu vi a necessidade de acrescentar a taxa_ocupacao, pelo fato que de há dois eventos
    com o mesmo nome, Rock In Rio.
*/

-- Questão 9: Qual evento teve a maior média diária de chamados abertos desse subtipo?
WITH contador AS (
  SELECT c.data_inicial ,c.evento,c.taxa_ocupacao ,DATE(b.data_inicio) AS dia, COUNT (*) AS total_chamados
  FROM `datario.adm_central_atendimento_1746.chamado` b
  JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` c
  ON DATE(b.data_inicio) BETWEEN DATE(c.data_inicial) AND DATE(c.data_final)
  WHERE b.subtipo = 'Perturbação do sossego'
  GROUP BY c.data_inicial, c.evento,c.taxa_ocupacao, dia
),

media_dias AS(
  SELECT data_inicial ,evento ,taxa_ocupacao, AVG(total_chamados) AS media_diaria
  FROM contador
  GROUP BY  data_inicial,evento, taxa_ocupacao
)

SELECT evento ,data_inicial, media_diaria,taxa_ocupacao
FROM media_dias
ORDER BY media_diaria DESC
LIMIT 4
/*
    Resposta: Aqui eu criei duas CTE's para auxiliar na legibilidade do código,
    então em contador eu faço a contagem em favor das condições e depois eu faço
    a média.
    
    Evento com maior média: Rock In Rio (02-09-2022) = 122,0 
*/

/* Questão 10: 
    Compare as médias diárias de chamados abertos desse subtipo durante os eventos específicos
    (Reveillon, Carnaval e Rock in Rio) e a média diária de chamados abertos
    desse subtipo considerando todo o período de 01/01/2022 até 31/12/2023.
*/
WITH 
contador AS (
  SELECT c.data_inicial, c.evento, c.taxa_ocupacao, DATE(b.data_inicio) AS dia, COUNT(*) AS total_chamados
  FROM `datario.adm_central_atendimento_1746.chamado` b
  JOIN `datario.turismo_fluxo_visitantes.rede_hoteleira_ocupacao_eventos` c
  ON DATE(b.data_inicio) BETWEEN DATE(c.data_inicial) AND DATE(c.data_final)
  WHERE b.subtipo = 'Perturbação do sossego'
  GROUP BY c.data_inicial, c.evento, c.taxa_ocupacao, dia
),

media_dias AS (
  SELECT data_inicial, evento, taxa_ocupacao, AVG(total_chamados) AS media_diaria
  FROM contador
  GROUP BY data_inicial, evento, taxa_ocupacao
),

-- Ordena em ordem Decrescente
top_media_dias AS (
  SELECT evento, data_inicial, media_diaria, taxa_ocupacao
  FROM media_dias
  ORDER BY media_diaria DESC
  LIMIT 4
),

contador_geral AS (
  SELECT DATE(data_inicio) AS dia, COUNT(*) AS total_chamados_geral
  FROM `datario.adm_central_atendimento_1746.chamado`
  WHERE subtipo = 'Perturbação do sossego'
    AND DATE(data_inicio) BETWEEN '2022-01-01' AND '2023-12-31'
  GROUP BY dia
),

media_total AS (
  SELECT AVG(total_chamados_geral) AS media_diaria_geral
  FROM contador_geral
)

-- União entre os eventos e a "Media Geral"
SELECT 
  evento, 
  data_inicial, 
  media_diaria, 
  taxa_ocupacao, 
  NULL AS media_diaria_geral
FROM 
  top_media_dias

UNION ALL

SELECT 
  'Media Geral' AS evento, 
  NULL AS data_inicial, 
  NULL AS media_diaria, 
  NULL AS taxa_ocupacao, 
  media_diaria_geral
FROM 
  media_total;

/*
    Resposta: Média diaria geral : ~62.
    É interessante comparar pois, temos praticamente o dobro da média no evento 
    Rock In Rio, o que faz sentido já que a cidade está muito mais movimentada
    do que o normal, mas vale lembrar que não é uma comparação tão justa, já que
    o evento do Rock In Rio dura pouco dias e o periodo que usadmos para a média geral
    é de quase dois anos, mas mesmo assim temos uma resultado interessante de se analisar.
*/
