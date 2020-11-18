#!/bin/bash
chmod 666 /var/run/docker.sock

CONTAINER_NAME=sandbox

docker inspect --type=image $CONTAINER_NAME > /dev/null 2>&1 \
    && docker build -t $CONTAINER_NAME server/container

cd server && npm start &
cd client && npm run serve  