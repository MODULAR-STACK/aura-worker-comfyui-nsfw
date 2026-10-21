FROM runpod/worker-comfyui:5.4.1-base
RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git /comfyui/custom_nodes/ComfyUI_IPAdapter_plus
