FROM python:3.11-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# CPU 版 torch（避免 2GB CUDA 包）+ whisper
RUN pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu \
 && pip install --no-cache-dir openai-whisper imageio-ffmpeg

# 预下载 whisper small 模型进镜像（~461MB，构建期一次）
ENV XDG_CACHE_HOME=/opt/whisper_cache
RUN python3 -c "import whisper; whisper.load_model('small')"

ENV OMP_NUM_THREADS=2
