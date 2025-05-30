# Título do Projeto: Pipeline de Automação e Análise de Dados de ISTs

---

## Objetivo e Descrição da Solução

Este projeto tem como objetivo principal demonstrar a construção e automação de um **pipeline de dados** completo, desde a geração de dados simulados até a análise, visualização e aplicação de modelos de Machine Learning (ML) em um contexto de saúde pública, focado em **Infecções Sexualmente Transmissíveis (ISTs)**.

A solução é modularizada usando **Docker Compose**, o que garante um ambiente de desenvolvimento e execução isolado, consistente e reprodutível. O pipeline abrange as seguintes etapas:

1.  **Geração de Dados Simulados:** Um serviço dedicado em Python cria um conjunto de dados simulados de registros de pacientes, incluindo informações demográficas, de saúde e de localização.
2.  **Armazenamento de Dados:** Um banco de dados **PostgreSQL** é utilizado como o Data Lake/Warehouse, armazenando os dados gerados de forma estruturada.
3.  **Análise de Dados com R:** Um serviço em R realiza análises exploratórias e transformações nos dados.
4.  **Processamento e Análise de Big Data (Spark):** Um serviço em Python/PySpark executa um notebook Jupyter (de forma automatizada) para realizar:
    - Pré-processamento avançado e engenharia de features.
    - Processamento de Linguagem Natural (PLN) em campos textuais.
    - Construção de um Data Warehouse com dimensões e tabelas fato.
    - Análises OLAP (Online Analytical Processing).
    - Aplicação de modelos de Classificação (Regressão Logística, Random Forest, Naive Bayes) para prever a presença de ISTs.
    - Aplicação de modelos de Clusterização (K-Means) para identificar perfis de pacientes.
    - Geração de visualizações e gráficos detalhados.
5.  **Visualização e Monitoramento (Grafana):** Uma instância do Grafana é configurada para criar dashboards interativos, permitindo a visualização e monitoramento dos dados e resultados das análises.
6.  **Controle de CI/CD (jenkins):** Para automatizar a integração contínua (CI) e a entrega contínua (CD) deste pipeline de dados.

## Tecnologias Utilizadas

- **Docker** e **Docker Compose**: Para orquestração e gerenciamento dos containers e do ambiente de desenvolvimento.
- **Python 3.9**: Utilizado nos serviços de `gerador-dados` e `bigdata`, bem como para as bibliotecas de análise.
  - **PySpark 3.4.4**: Framework de processamento de Big Data.
  - **Pandas**: Manipulação e análise de dados em Python.
  - **Numpy**: Computação numérica em Python.
  - **Scikit-learn**: Modelos de Machine Learning (classificação e clusterização).
  - **Matplotlib**, **Seaborn**, **Plotly**, **Folium**: Bibliotecas para visualização e criação de mapas interativos.
  - **Faker**: Geração de dados simulados.
- **R**: Utilizado no serviço `analise-r` para análises estatísticas e transformações.
  - **`knitr`, `ggplot2`, `dplyr`, `tidyr`, `tools`, `RPostgreSQL`**: Pacotes R para análise e manipulação de dados, e conexão com PostgreSQL.
- **PostgreSQL 15**: Banco de dados relacional para armazenamento de dados.
- **Grafana 10.4.1**: Plataforma de visualização e monitoramento.

---

## Como Instalar e Executar o Projeto

Siga os passos abaixo para configurar e executar o pipeline completo em sua máquina local.

### Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas em seu sistema operacional:

- **Docker Desktop**: Inclui Docker Engine e Docker Compose.
  - [Download Docker Desktop](https://www.docker.com/products/docker-desktop)

### Estrutura do Projeto

A estrutura de diretórios do projeto deve ser organizada da seguinte forma:

```
ProjetoDataScience/
├── docker-compose.yml # Orquestração de todos os serviços Docker
├── .gitignore # Arquivos e pastas a serem ignorados pelo Git
├── Jenkinsfile # Arquivo de configuração Jenkins para CI/CD
├── README.md
│
├── data/ # Diretório para dados de entrada (CSV)
│
├── bigdata/ # Serviço de processamento e análise de Big Data (Python/Spark)
│ ├── Dockerfile # Define a imagem Docker para o serviço
│ ├── main.ipynb # Notebook Jupyter principal com análises e ML
│
├── bigdata_output/ # Diretório de saída dos notebooks e gráficos gerados
│
├── analise_r/ # Serviço de análise de dados com R
│ ├── Dockerfile # Define a imagem Docker para o serviço
│ └── analise.R # Script R de análise
│ └── wait_for_file.sh # Script de espera para arquivos
│
├── gerador_dados/ # Serviço de geração de dados (Python)
│ ├── Dockerfile # Define a imagem Docker para o serviço
│ └── gerador_dados.py # Script Python para geração de dados
│
├── grafana/ # Configurações do Grafana
│ ├── provisioning/
│ │ └── dashboards/ # Provisão de dashboards
│ │ └── dashboard.json # Configuração de dashboard
│ └── dashboards/ # Dashboards reais
│
├── jenkins_custom/ # Arquivos de configuração Jenkins customizados
│ ├── Dockerfile # Define a imagem Docker para o serviço
```

### Passos para Execução

1.  **Navegue até o Diretório do Projeto:**
    Abra seu terminal ou prompt de comando e navegue até o diretório raiz do projeto `ProjetoDataScience/` (onde o arquivo `docker-compose.yml` está localizado).

    ```bash
    cd /caminho/para/ProjetoDataScience
    ```

2.  **Crie a Pasta de Saída:**
    Crie o diretório `bigdata_output` na raiz do projeto. Este diretório será usado para armazenar o notebook executado (`resultado_main.ipynb`) e os gráficos/mapas gerados.

    ```bash
    mkdir bigdata_output
    ```

3.  **Execute o Docker Compose:**
    O comando abaixo irá construir as imagens Docker para cada serviço (se ainda não existirem ou se houver alterações no `Dockerfile`) e iniciar todos os containers definidos no `docker-compose.yml`.

    ```bash
    docker compose up --build
    ```

    - A flag `--build` é crucial, pois ela força o Docker a reconstruir as imagens, garantindo que todas as dependências e alterações nos Dockerfiles sejam aplicadas.
    - Se você quiser rodar apenas o serviço `bigdata` e suas dependências (ignorando `gerador_dados` e `analise_r` temporariamente se já tiver dados), pode usar `docker compose up --build bigdata`. No entanto, para o pipeline completo, `docker compose up --build` é o ideal.

4.  **Acompanhe os Logs:**
    Você verá os logs de todos os containers sendo exibidos no terminal. Preste atenção aos logs do container `bigdata`, pois ele estará executando o notebook Jupyter.

    - Você pode usar `docker compose logs bigdata` em outra janela de terminal para ver apenas os logs do serviço `bigdata`.
    - Para seguir os logs em tempo real, use `docker compose logs -f bigdata`.

5.  **Verifique os Resultados:**
    Após a conclusão da execução de todos os serviços (o container `bigdata` deve parar após o `nbconvert` terminar), navegue até a pasta `bigdata_output/`.

    ```bash
    ls bigdata_output/
    ```

    Você deverá encontrar os seguintes arquivos:

    - `resultado_main.ipynb`: O notebook Jupyter com todas as células executadas e suas saídas (incluindo gráficos incorporados).
    - `matriz_confusao.png`: Imagem da matriz de confusão.
    - `curva_roc.png`: Imagem da curva ROC.
    - `metodo_cotovelo.png`: Imagem do gráfico do método do cotovelo.
    - `clusters_kmeans.png`: Imagem da visualização dos clusters.
    - `mapa_casos_localidade.html`: Arquivo HTML interativo do mapa.

    Você pode abrir esses arquivos diretamente para visualizar os resultados da análise.

6.  **Parar e Remover os Containers (Opcional):**
    Quando terminar de usar o ambiente, você pode parar e remover todos os containers, redes e volumes criados pelo Docker Compose (exceto volumes nomeados como `pgdata` e `grafana-data`, que persistem para manter seus dados).

    ```bash
    docker compose down
    ```

    - Se quiser remover também os volumes nomeados (e, portanto, os dados do PostgreSQL e Grafana), use:
      ```bash
      docker compose down -v
      ```
