# Desafio Técnico - Cientista de Dados Júnior

## Descrição
Esse repositório contém todas as resoluções do desafio e também a visualização do relatório no Power BI.

## Informações Importantes
Durante a instalação da biblioteca `basedosdados` encontrei algumas dificuldades e erros neste processo, e aqui segue os métodos que eu utilizei para conseguir instalar a biblioteca, caso você se encontre na mesma situação. Vale ressaltar que, infelizmente eu acabei realizando mais de um procedimento ao mesmo tempo, então não sei ao certo qual método de fato resolveu o meu problema.

### 1º Método:
Antes da instalação meu a versão do meu Python era 3.12.3, então decidi colocar a versão 3.10 e aparentemente essa foi a solução para meu problema, porém ao fazer isso eu tive alguns problemas de compatibilidade com as versões do `NumPy` e outras bibliotecas que o `basedosdados` usa, então a biblioteca não funcionava corretamente, dessa forma eu voltei para a versão 3.12.3 e tudo continuou funcionando e agora da forma correta

### 2º Método:
Instalar a versão do `basedosdados` 2.0.0b15.

## Como utilizar os códigos:
Faça o clone deste repositório, para que você consiga usar tudo sem problemas, por exemplo eu fiz algumas alterações manuais no descriptions.json, então caso não utilize a minha versão, você encontrará resultados diferentes. Você irá precisar usar uma IDE ou editor de texto como o Visual Studio Code.

### Análise SQL:
Copie todo o conteúdo do arquivo e rode numa consulta do BigQuery. 

Note que, todas as consultas de uma vez só irá consumir 4,69 GB da sua cota do BigQuery, então tome cuidado com sua cota.

### Análise Python:
Permita a instalação das bibliotecas quando rodar o código na primeira vez, depois disso você pode comentar a célula do `pip install`.

#### Passo para usar o Google BigQuery
- 1º Passo: Acesse [Console do Google Cloud](https://console.cloud.google.com/)
- 2º Passo: Pesquise BigQuery na barra de pesquisa e clique
- 3º Passo: Ao lado do icone do Google Cloud, você perceberá um campo de seleção, clique nele e crie um novo projeto
- 4º Passo: Com o projeto criado você terá o seu project_id e está apto para rodar o código.


Note que, temos sempre o uso de `billing_project_id=project_id`, em `project_id` deve colocar o id do `seu` projeto do BigQuery, caso não possua, deverá criar um. Ao passo que, na primeira vez em que o código for executado, abrirá uma aba no google, pedindo para que faça login em uma conta, certifique-se que está logando na conta que foi utilizada para criar o projeto no BigQuery.

Após isso, basta rodar o código usando a sua IDE de preferência.

### Análise API:
Permita a instalação das bibliotecas quando rodar o código na primeira vez, depois disso você pode comentar a célula do `pip install`.

Caso você vá rodar o código fora da pasta onde ele se encontra, lembre de deixar o arquivo `descriptions.json` na mesma pasta que o arquivo `analise_api.ipynb`.

Após isso, basta rodar o código.

Ao final do arquivo, você verá uma parte voltada para Power BI, que está comentada, deixa essa parte comentada, se não o código não funcionará corretamente, essa parte é irrelevante para o usuário final, porém eu utilizei para alimentar as bases de dados para os meus relatório no Power BI.

## Visualização com Dashboard no Power BI
Segue o Link para a Dashboard : [Dashboard Power BI](https://app.powerbi.com/view?r=eyJrIjoiYzg5NTcyZTEtM2MwYi00NTAxLTk4MjgtZGM4MDdkYmE5NGE2IiwidCI6IjRhMTdkOTBkLWM3NzAtNDMwNi1hODUxLTc2MDM4MTJhZTUzYyJ9&pageName=67d2f56553dd24a29edf)



