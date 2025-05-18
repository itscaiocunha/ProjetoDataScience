FROM r-base:latest

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && apt-get clean

WORKDIR /app

# Instala pacotes R necessários
RUN R -e "install.packages(c('knitr', 'ggplot2', 'dplyr', 'tidyr', 'tools'), repos='http://cran.r-project.org')"

# Copia o script R e o script de espera
COPY analise.R .
COPY wait_for_file.sh .

# Dá permissão de execução ao script
RUN chmod +x wait_for_file.sh

# Usa o script como comando principal
CMD ["./wait_for_file.sh"]
