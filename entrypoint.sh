#!/bin/bash

# Setup ComfyUI
if [ ! -d "/app/ComfyUI" ]; then
    echo "Cloning ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git /app/ComfyUI
    cd /app/ComfyUI
    echo "Checking out ComfyUI version: ${COMFYUI_VERSION:-v0.3.60}"
    git checkout ${COMFYUI_VERSION:-v0.3.60}
    pip install -r requirements.txt
else
    cd /app/ComfyUI
    # Check if it's a valid git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "ComfyUI directory exists but is not a git repository. Initializing git repo..."
        # Initialize git repo in existing directory
        git init
        git remote add origin https://github.com/comfyanonymous/ComfyUI.git
        git fetch origin
        echo "Checking out ComfyUI version: ${COMFYUI_VERSION:-v0.3.60}"
        # Force checkout to handle untracked files in mounted directories
        git checkout -f ${COMFYUI_VERSION:-v0.3.60}
        pip install -r requirements.txt
    else
        CURRENT_VERSION=$(git describe --tags --exact-match 2>/dev/null || git rev-parse --short HEAD)
        TARGET_VERSION=${COMFYUI_VERSION:-v0.3.60}
        if [ "$CURRENT_VERSION" != "$TARGET_VERSION" ]; then
            echo "Updating ComfyUI from $CURRENT_VERSION to $TARGET_VERSION"
            git fetch --tags
            git checkout -f $TARGET_VERSION
            pip install -r requirements.txt
        fi
    fi
fi

# Install ComfyUI Manager
if [ ! -d "/app/ComfyUI/custom_nodes/ComfyUI-Manager" ]; then
    echo "Installing ComfyUI Manager..."
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git /app/ComfyUI/custom_nodes/ComfyUI-Manager
fi

# Install ComfyUI-Crystools
if [ ! -d "/app/ComfyUI/custom_nodes/ComfyUI-Crystools" ]; then
    echo "Installing ComfyUI-Crystools..."
    git clone https://github.com/crystian/ComfyUI-Crystools.git /app/ComfyUI/custom_nodes/ComfyUI-Crystools
    cd /app/ComfyUI/custom_nodes/ComfyUI-Crystools
    pip install -r requirements.txt
    cd /app/ComfyUI
fi

exec python main.py --listen 0.0.0.0 --port 8188 "$@"
