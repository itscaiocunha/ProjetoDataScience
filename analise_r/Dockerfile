FROM r-base:latest

WORKDIR /app

# Instala os pacotes necessários
RUN R -e "install.packages(c('rmarkdown', 'knitr', 'ggplot2', 'dplyr', 'tidyr', 'tools'), repos='http://cran.r-project.org')"

# Copia o arquivo de análise
COPY analise.Rmd .

# Comando para renderizar o Rmd como HTML (ou outro formato)
CMD ["R", "-e", "rmarkdown::render('analise.Rmd', output_format = 'html_document')"]
