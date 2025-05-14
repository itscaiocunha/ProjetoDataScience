FROM r-base:latest

# Instala dependências do sistema necessárias para pacotes R
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean

WORKDIR /app

# Instala pacotes R necessários
RUN R -e "install.packages(c('knitr', 'ggplot2', 'dplyr', 'tidyr', 'tools'), repos='http://cran.r-project.org')"

# Copia o script de análise
COPY analise.R .

# Comando padrão: executa o script
CMD ["Rscript", "analise.R"]
