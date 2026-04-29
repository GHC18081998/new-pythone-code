#!/bin/bash
REGISTRY_URL=$(aws ssm get-parameter --name "/myapp/docker/registry_url" --query "Parameter.Value" --output text)

# Login again on the EC2 instance to pull the image
DOCKER_USER=$(aws ssm get-parameter --name "/myapp/docker/username" --query "Parameter.Value" --output text)
DOCKER_PASS=$(aws ssm get-parameter --name "/myapp/docker/password" --with-decryption --query "Parameter.Value" --output text)
echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin $REGISTRY_URL

docker pull $REGISTRY_URL:latest
docker run -d -p 5000:5000 --name flask-app $REGISTRY_URL:latest
