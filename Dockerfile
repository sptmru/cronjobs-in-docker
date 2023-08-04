FROM ubuntu:22.04
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get install -y gnupg curl wget \
    && curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
      gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
       --dearmor \
    && echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list \
    && echo "deb http://apt.postgresql.org/pub/repos/apt jammy-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
      tee /etc/apt/trusted.gpg.d/pgdg.asc \
    && apt-get update && apt-get install -y cron postgresql-client-15 postgresql-client-common libpq-dev mongodb-org

WORKDIR app
