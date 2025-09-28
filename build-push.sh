#!/bin/bash
set -e

# Default version or use first argument
COMFYUI_VERSION=${1:-v0.3.59}
REGION="us-west-2"

# Get AWS account ID dynamically
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REPO="${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/comfyui-images"

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
