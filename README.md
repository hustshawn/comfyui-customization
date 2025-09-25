# ComfyUI Build

A containerized ComfyUI deployment with Docker and Kubernetes support, featuring persistent storage for workspace and models.

## Quick Start

### Local Development
```bash
git clone https://github.com/shawnawshk/comfyui-customization.git
cd comfyui-customization
docker compose up --build
```

### Kubernetes Deployment
```bash
kubectl apply -f manifest.yaml
```

## Files

- **Dockerfile** - Container image definition for ComfyUI
- **docker-compose.yml** - Docker Compose configuration for local development  
- **entrypoint.sh** - Container startup script that handles ComfyUI setup
- **build-push.sh** - Script to build and push Docker images
- **manifest.yaml** - Kubernetes deployment manifest with EBS and S3 storage
- **qwen-image-models-list.txt** - List of Qwen image model URLs for download

## Storage Architecture

### EBS Volumes
- **comfyui-data-pvc** (100Gi): Consolidated volume with subpaths
  - `/workspace` - ComfyUI project files and custom nodes
  - `/opt/venv` - Python virtual environment

### S3 Storage
- **Bucket**: `comfyui-storage-20250921-us-west-2`
  - `inputs/` prefix - Input files and assets
  - `outputs/` prefix - Generated images and videos

### Host Storage
- `/mnt/k8s-disks/0/comfyui-models` - Pre-downloaded models
- `/mnt/k8s-disks/0/videos` - Video output storage

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

**Download Qwen models:**
```bash
# Use the URLs from qwen-image-models-list.txt
wget -i qwen-image-models-list.txt
```
