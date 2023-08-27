#!/usr/bin/env bash

# Ensure the log file exists
mkdir /app/logs
touch /app/logs/crontab.log

# Add cronjobs in a new crontab

# postgres dump
echo "0 1 * * * PGPASSWORD=\"$POSTGRES_PASSWORD\" /usr/bin/pg_dump -Fc -h \"$POSTGRES_IP_ADDRESS\" -p \"$POSTGRES_PORT\" -U \"$POSTGRES_USER\" \"$POSTGRES_DATABASE\" > /app/backups/postgres_dump.sql >> /app/logs/crontab.log 2>&1" > /etc/crontab
# postgres restore
echo "0 0 * * 0 PGPASSWORD=\"$POSTGRES_PASSWORD\" /usr/bin/pg_restore /app/backups/postgres_dump.sql -d \"$POSTGRES_DATABASE\" -h \"$POSTGRES_IP_ADDRESS\" -p \"$POSTGRES_PORT\" -U \"$POSTGRES_USER\" >> /app/logs/crontab.log 2>&1" > /etc/crontab

# mongo dump
echo "0 1 * * * /usr/bin/mongodump --host=\"$MONGO_IP_ADDRESS\" --port=\"$MONGO_PORT\" --username=\"$MONGO_INITDB_ROOT_USERNAME\" --password=\"$MONGO_INITDB_ROOT_PASSWORD\" --out=/app/backup/mongo_dump  >> /app/logs/crontab.log 2>&1" > /etc/crontab
# mongo restore
echo "0 0 * * 0 /usr/bin/mongorestore --host=\"$MONGO_IP_ADDRESS\" --port=\"$MONGO_PORT\" --username=\"$MONGO_INITDB_ROOT_USERNAME\" --password=\"$MONGO_INITDB_ROOT_PASSWORD\" /app/backup/mongo_dump  >> /app/logs/crontab.log 2>&1" > /etc/crontab

# redis backup
echo "0 1 * * * /usr/bin/tar czvf /app/backups/redis.tar.gz /redis/appendonlydir"
# redis restore
echo "0 0 * * 0 /usr/bin/tar xf /app/backups/redis.tar.gz -C /tmp/ && /usr/bin/rm /redis/appendonlydir/* && /usr/bin/mv /tmp/redis/appendonlydir/* /redis && /usr/bin/rm -rf /tmp/redis"

# Registering the new crontab
crontab /etc/crontab

# Starting the cron
/usr/sbin/service cron start

# Displaying logs
# Useful when executing docker-compose logs mycron
tail -f /app/logs/crontab.log
