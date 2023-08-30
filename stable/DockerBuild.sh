#!/bin/sh

docker build -t ib_gateway-image .
docker image tag ib_gateway-image:latest ib_gateway-image:stable

docker run -d   --name iTraderBot.IB.Gateway \
                --restart always \
                --network iTradeBotNetwork \
                --env-file .env \
                -p 4001:4001 \
                -p 4002:4002 \
                -p 5900:5900 \
                ib_gateway-image:stable

# ##############################################
# The following is using docker service
# we have issue with --network iTradeBotNetwork
# ##############################################
docker service rm IBGateway-Service     # remove existing services
docker service create \
            --name IBGateway-Service \
            --network iTradeBotNetwork \
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