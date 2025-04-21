FROM mysql:8.0

# Copia o init.sql para o diretório correto
COPY ./docker/mysql/init.sql /docker-entrypoint-initdb.d/

# Garante permissões corretas
RUN chmod -R 644 /docker-entrypoint-initdb.d/*