#!/bin/bash

# Clone ComfyUI if it doesn't exist
if [ ! -d "/workspace/ComfyUI" ]; then
    echo "Cloning ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git /workspace/ComfyUI
    cd /workspace/ComfyUI
    pip install -r requirements.txt
fi

cd /workspace/ComfyUI
exec python main.py --listen 0.0.0.0 --port 8188 "$@"
