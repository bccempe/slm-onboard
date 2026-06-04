sudo swapoff -a 2>/dev/null || true
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

sudo dpkg --configure -a 2>/dev/null || true

sudo apt update

sudo apt install -y \
  git \
  cmake \
  build-essential \
  pkg-config \
  libopenblas-dev \
  python3-pip

pip install --user --break-system-packages huggingface-hub

mkdir -p ~/models
cd ~/models

hf download bartowski/Qwen2.5-0.5B-Instruct-GGUF \
  Qwen2.5-0.5B-Instruct-Q4_K_M.gguf --local-dir .

hf download bartowski/Qwen2.5-0.5B-Instruct-GGUF \
  Qwen2.5-0.5B-Instruct-Q4_0.gguf --local-dir .

hf download bartowski/Qwen2.5-0.5B-Instruct-GGUF \
  Qwen2.5-0.5B-Instruct-Q3_K_M.gguf --local-dir .

ls -lh ~/models/  

LLAMAFILE_VERSION="0.10.3"

curl -L "https://github.com/mozilla-ai/llamafile/releases/download/$LLAMAFILE_VERSION/llamafile-$LLAMAFILE_VERSION" \
  -o ~/llamafile

curl -L "https://github.com/mozilla-ai/llamafile/releases/download/$LLAMAFILE_VERSION/llamafile-$LLAMAFILE_VERSION-thin" \
  -o ~/llamafile-thin

chmod +x ~/llamafile ~/llamafile-thin
sudo cp ~/llamafile /usr/local/bin/llamafile
sudo cp ~/llamafile-thin /usr/local/bin/llamafile-thin
sudo setcap cap_ipc_lock+ep /usr/local/bin/llamafile 2>/dev/null || true

