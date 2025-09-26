#!/bin/bash

# Clone ComfyUI if it doesn't exist
if [ ! -d "/workspace/ComfyUI" ]; then
    echo "Cloning ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
    cd /workspace/ComfyUI
    pip install -r requirements.txt
fi

cd /workspace/ComfyUI

# Install ComfyUI Manager
if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Manager" ]; then
    echo "Installing ComfyUI Manager..."
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git /workspace/ComfyUI/custom_nodes/ComfyUI-Manager
fi

# Install ComfyUI-Crystools
if [ ! -d "/workspace/ComfyUI/custom_nodes/ComfyUI-Crystools" ]; then
    echo "Installing ComfyUI-Crystools..."
    git clone https://github.com/crystian/ComfyUI-Crystools.git /workspace/ComfyUI/custom_nodes/ComfyUI-Crystools
    cd /workspace/ComfyUI/custom_nodes/ComfyUI-Crystools
    pip install -r requirements.txt
    cd /workspace/ComfyUI
fi

exec python main.py --listen 0.0.0.0 --port 8188 "$@"
