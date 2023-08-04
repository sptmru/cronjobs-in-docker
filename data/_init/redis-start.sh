#!/bin/sh

redis-server --requirepass "$REDIS_PASSWORD" --port ${REDIS_PORT} --bind ${REDIS_IP_ADDRESS} --appendonly yes

