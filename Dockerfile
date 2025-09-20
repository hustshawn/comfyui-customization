FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

ARG COMFYUI_VERSION=v0.3.40

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    python3.10 \
    python3-pip \
    python3-venv \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install PyTorch with matching CUDA version
RUN pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install ComfyUI-Manager dependencies
RUN pip install GitPython toml

# Clone and setup ComfyUI
RUN git clone https://github.com/comfyanonymous/ComfyUI.git
WORKDIR /app/ComfyUI
RUN git checkout ${COMFYUI_VERSION}
RUN pip install -r requirements.txt

# Install ComfyUI Manager
RUN cd custom_nodes && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git comfyui-manager

# Create user and directories with proper permissions
RUN useradd -m -u 1000 comfyui && \
    mkdir -p models/{diffusion_models,text_encoders,vae,loras,checkpoints,clip,unet} \
             input output temp && \
    chown -R comfyui:comfyui /opt/venv /app && \
    chmod -R 777 /app/ComfyUI/models /app/ComfyUI/input /app/ComfyUI/output && \
    chmod -R 755 /app

# Set ComfyUI-Manager security level to weak
RUN sed -i 's/security_level = .*/security_level = weak/' /app/ComfyUI/custom_nodes/comfyui-manager/config.ini || \
    (mkdir -p /app/ComfyUI/user/default/ComfyUI-Manager && \
     echo -e "[default]\nsecurity_level = weak" > /app/ComfyUI/user/default/ComfyUI-Manager/config.ini) && \
    chown -R comfyui:comfyui /app/ComfyUI/user

# Add health check script
RUN echo '#!/bin/bash\ncurl -f http://localhost:8188/system_stats || exit 1' > /app/healthcheck.sh && \
    chmod +x /app/healthcheck.sh

# Create startup script to fix permissions at runtime
RUN echo '#!/bin/bash' > /app/fix-permissions.sh && \
    echo 'chown -R comfyui:comfyui /app/ComfyUI/models /app/ComfyUI/input /app/ComfyUI/output 2>/dev/null || true' >> /app/fix-permissions.sh && \
    echo 'chmod -R 777 /app/ComfyUI/models /app/ComfyUI/input /app/ComfyUI/output 2>/dev/null || true' >> /app/fix-permissions.sh && \
    echo 'exec "$@"' >> /app/fix-permissions.sh && \
    chmod +x /app/fix-permissions.sh

USER comfyui

EXPOSE 8188
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD ["/app/healthcheck.sh"]

ENTRYPOINT ["/app/fix-permissions.sh"]
CMD ["python3", "main.py", "--listen", "0.0.0.0", "--port", "8188"]
