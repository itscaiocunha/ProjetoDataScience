# Use uma imagem base com Java e Python
FROM openjdk:8-jdk-slim as spark-base

# Instalar Python e pip (se não estiverem na imagem base)
RUN apt-get update && \
    apt-get install -y python3 python3-pip curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Definir a versão do Spark
ENV SPARK_VERSION 3.2.0
ENV HADOOP_VERSION 3.2

# Baixar e extrair o Apache Spark
RUN curl -o /tmp/spark.tgz https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
    tar -xvf /tmp/spark.tgz -C /opt && \
    rm /tmp/spark.tgz

# Criar um link simbólico para a pasta Spark para facilitar o acesso
RUN ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

# Variáveis de ambiente para o Spark
ENV SPARK_HOME /opt/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.9.2-src.zip:$PYTHONPATH
ENV JAVA_HOME /usr/local/openjdk-8

# Instalar findspark
RUN pip install findspark

# Copiar o arquivo requirements.txt e instalar as dependências Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

# Criar diretório para o código e os dados
WORKDIR /app
COPY . /app/

# O comando padrão para rodar o script PySpark
CMD ["spark-submit", "main.py"]