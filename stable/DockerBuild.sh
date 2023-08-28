#!/bin/sh

docker build -t ib_gateway-image .
docker image tag ib_gateway-image:latest ib_gateway-image:stable

docker service rm IBGateway-Service     # remove existing services
docker service create \
            --name IBGateway-Service \
            --reserve-memory=2GB \
            --replicas 1 \
            --secret iTraderBot_UID \
            --secret iTraderBot_PWD \
            --secret iTraderBot_VNC \
            --env-file .env \
            --publish published=4001,target=4001,mode=host \
            --publish published=4002,target=4002,mode=host \
            --publish published=5900,target=5900,mode=host \
        ib_gateway-image:stable