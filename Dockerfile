FROM runpod/worker-comfyui:5.4.1-base

# IP-Adapter (reference lock) — commercially clean, CLIP-based
RUN git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git /comfyui/custom_nodes/ComfyUI_IPAdapter_plus

# Real upscale model (Real-ESRGAN x4plus, BSD-3-Clause — clean for commercial) for 4K-sharp hi-res
RUN mkdir -p /comfyui/models/upscale_models \
 && wget -O /comfyui/models/upscale_models/RealESRGAN_x4plus.pth \
    https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth

# ControlNet preprocessors (comfyui_controlnet_aux). Commercial-clean preprocessors
# ONLY in this build: Canny (OpenCV — no model) and Depth-Anything V2 (Apache-2.0).
# We DO NOT enable CMU OpenPose (non-commercial) or any ultralytics/YOLO detector
# (AGPL) here — those are a separate follow-up pending a verified-permissive detector.
RUN git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git /comfyui/custom_nodes/comfyui_controlnet_aux \
 && pip install --no-cache-dir -r /comfyui/custom_nodes/comfyui_controlnet_aux/requirements.txt

# The worker has NO internet at runtime — bake the Depth-Anything V2 (Small, Apache-2.0)
# weights so the depth preprocessor runs FULLY OFFLINE. Canny needs no model. The
# OFFLINE env vars make any missing annotator FAIL FAST instead of silently trying to
# download at runtime (verify the ckpts path in the build log against the node version).
RUN mkdir -p /comfyui/custom_nodes/comfyui_controlnet_aux/ckpts/depth-anything/Depth-Anything-V2-Small \
 && wget -O /comfyui/custom_nodes/comfyui_controlnet_aux/ckpts/depth-anything/Depth-Anything-V2-Small/depth_anything_v2_vits.pth \
    https://huggingface.co/depth-anything/Depth-Anything-V2-Small/resolve/main/depth_anything_v2_vits.pth
ENV HF_HUB_OFFLINE=1 TRANSFORMERS_OFFLINE=1

# Map volume model folders (incl. ipadapter — the empty-folder-crash fix — and
# controlnet, the standard folder for the xinsir SDXL Canny/Depth models on the volume).
COPY extra_model_paths.yaml /comfyui/extra_model_paths.yaml
