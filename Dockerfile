FROM runpod/worker-comfyui:5.4.1-base

# IP-Adapter (reference lock) — commercially clean, CLIP-based
RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git /comfyui/custom_nodes/ComfyUI_IPAdapter_plus

# Real upscale model (Real-ESRGAN x4plus, BSD-3-Clause — clean for commercial) for 4K-sharp hi-res
RUN mkdir -p /comfyui/models/upscale_models \
 && wget -O /comfyui/models/upscale_models/RealESRGAN_x4plus.pth \
    https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth

# Map volume model folders (incl. the ipadapter folder — the fix for the empty-folder crash)
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml
