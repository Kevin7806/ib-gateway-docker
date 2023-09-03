# Interactive Brokers Gateway Docker Stable Release

A docker image to run the Interactive Brokers Gateway Application without any human interaction on a docker container.

## How to build?

Run following command to build container image

```
# Build image with latest code in stable folder
docker build -t ib_gateway-image .

# Tag this image as stable release
docker image tag ib_gateway-image:latest ib_gateway-image:stable

# Tag stable release for AWS ECR
docker image tag ib_gateway-image:stable 715153891427.dkr.ecr.us-east-2.amazonaws.com/ib_gateway-image:stable

# Get AWS access token
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 715153891427.dkr.ecr.us-east-2.amazonaws.com

# Push to AWS ECR
docker push 715153891427.dkr.ecr.us-east-2.amazonaws.com/ib_gateway-image:stable
```

## How to run?

It require to have .env file to configure envrionment variables. The following is an example

```
TWS_USERID=******************
TWS_PASSWORD=****************
VNC_SERVER_PASSWORD=*********
TRADING_MODE=live               # The allowed values are 'live' and 'paper'.
READ_ONLY_API=no
IB_AUTO_CLOSE_DOWN=no
CLOSE_DOWN_AT=Friday 23:59
TZ=America/Chicago
```

Use following to run container
```
docker run -d   --name iTraderBot.IB.Gateway \
                --restart always \
                --network iTradeBotNetwork \    # this is optional
                --env-file .env \               # this contains env value
                -p 4001:4001 \                  
                -p 4002:4002 \
                -p 5900:5900 \
                715153891427.dkr.ecr.us-east-2.amazonaws.com/ib_gateway-image:stable

```