FROM r-base:latest

WORKDIR /app

# Instala os pacotes necessários (incluindo knitr, ggplot2, dplyr, tidyr, etc.)
RUN R -e "install.packages(c('knitr', 'ggplot2', 'dplyr', 'tidyr', 'tools'), repos='http://cran.r-project.org')"

# Copia o script de análise para o container
COPY analise.R .

# Comando padrão (ajustado para rodar automaticamente)
CMD ["Rscript", "analise.R"]
