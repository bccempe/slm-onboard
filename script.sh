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

cd ~
export TMPDIR=/home/pi/tmp
mkdir -p /home/pi/tmp
git clone --depth 1 https://github.com/ggerganov/llama.cpp
cd llama.cpp

cmake -B build \
  -DGGML_NATIVE=OFF \
  -DGGML_BLAS=ON \  
  -DGGML_BLAS_VENDOR=OpenBLAS \
  -DCMAKE_BUILD_TYPE=Release

cmake --build build --config Release -j2

sudo cp build/bin/llama-cli /usr/local/bin/
sudo cp build/bin/llama-server /usr/local/bin/
