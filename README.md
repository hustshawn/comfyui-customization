# ComfyUI Build

A containerized ComfyUI deployment with Docker and Kubernetes support.

## Quick Start

### Local Development
```bash
git clone https://github.com/hustshawn/comfyui-customization.git
cd comfy-ui-build
docker compose up --build
```

### Kubernetes Deployment
```bash
kubectl apply -f manifest.yaml
```

## Files

- **Dockerfile** - Container image definition for ComfyUI
- **docker-compose.yml** - Docker Compose configuration for local development  
- **build-push.sh** - Script to build and push Docker images
- **manifest.yaml** - Kubernetes deployment manifest

## Usage

**Build and run locally:**
```bash
docker compose up --build
```

**Build and push image:**
```bash
./build-push.sh
```

**Deploy to Kubernetes:**
```bash
kubectl apply -f manifest.yaml
```
