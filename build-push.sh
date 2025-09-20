#!/bin/bash
set -e

# Default version or use first argument
COMFYUI_VERSION=${1:-v0.3.40}
ECR_REPO="985955614379.dkr.ecr.us-west-2.amazonaws.com/comfyui-images"
REGION="us-west-2"

echo "Building ComfyUI ${COMFYUI_VERSION}..."

# Build image with version build arg
docker build \
  --build-arg COMFYUI_VERSION=${COMFYUI_VERSION} \
  -t comfyui:${COMFYUI_VERSION} \
  -t comfyui:latest .

# Login to ECR
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REPO}

# Tag for ECR
docker tag comfyui:${COMFYUI_VERSION} ${ECR_REPO}:${COMFYUI_VERSION}
docker tag comfyui:latest ${ECR_REPO}:latest

# Push both tags
echo "Pushing ${COMFYUI_VERSION} and latest tags..."
docker push ${ECR_REPO}:${COMFYUI_VERSION}
docker push ${ECR_REPO}:latest

echo "Successfully pushed ComfyUI ${COMFYUI_VERSION} to ECR"
