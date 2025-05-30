# Use uma imagem base que já inclua OpenJDK 8
FROM eclipse-temurin:8-jdk-focal

# Instale Python 3.9 e pip, e as bibliotecas BLAS/LAPACK e ferramentas de compilação
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3.9 python3.9-distutils python3-pip libatlas-base-dev gfortran build-essential && \
    rm -rf /var/lib/apt/lists/*

# Crie um link simbólico para python3.9 como o python padrão
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

# Crie um link simbólico para o Java para que o PySpark o encontre no caminho esperado
RUN mkdir -p /usr/lib/jvm && \
    ln -s /opt/java/openjdk /usr/lib/jvm/java-8-openjdk-amd64

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Crie o diretório de saída para os gráficos e o notebook final
RUN mkdir -p /app/output

# Instale o Jupyter (para nbconvert) e todas as bibliotecas Python do seu notebook
# Usamos 'pip' diretamente, pois a imagem base já tem o Python 3.9 como padrão.
# A versão do pyspark é mantida em 3.4.4.
RUN pip install --no-cache-dir \
    jupyter \
    findspark \
    pyspark==3.4.4 \
    folium \
    seaborn \
    plotly \
    matplotlib \
    ipywidgets \
    scikit-learn \
    pandas \
    numpy \
    scipy

# Copie o notebook que você quer executar para dentro do container
# O caminho de origem agora é relativo ao contexto de build (raiz do projeto)
COPY bigdata/main.ipynb .

# Crie um diretório para os dados de entrada, se ainda não existir
RUN mkdir -p /data

# Copie o arquivo CSV para o diretório /data dentro do container
# O caminho de origem é relativo ao contexto de build (raiz do projeto)
COPY data/dados_ist_tratados.csv /data/dados_ist_tratados.csv

# Configure as variáveis de ambiente para o Spark (JAVA_HOME)
ENV JAVA_HOME="/opt/java/openjdk"

# Comando para executar o notebook automaticamente usando nbconvert
CMD ["jupyter", "nbconvert", "--to", "notebook", "--execute", "main.ipynb", "--output", "/app/output/resultado_main.ipynb", "--allow-errors"]
