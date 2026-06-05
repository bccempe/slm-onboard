# SLM Onboard

Provisioning script for Raspberry Pi / ARM64 Linux to run small language models locally using [llamafile](https://github.com/mozilla-ai/llamafile) (based on llama.cpp).

## Compatibilidad

- **Sistema**: Raspberry Pi OS / Debian Bookworm (o derivados)
- **Arquitectura**: ARM64 (aarch64)
- **RAM mínima**: 512 MB (con swap) / 1 GB (sin swap / con `--mlock`)
- **Probado en**: Raspberry Pi Zero 2 W 

## Dependencias

### Sistema
| Paquete | Propósito |
|---|---|
| `python3-pip` | Instalador de paquetes Python |
| `curl` | Descarga de binarios |

### Python
| Paquete | Propósito |
|---|---|
| `huggingface-hub` | Descarga de modelos GGUF desde Hugging Face |

## Instalación

```bash
git clone https://github.com/benjaminCanalesC/slm-onboard.git
cd slm-onboard
chmod +x script.sh
./script.sh
```

### ¿Qué hace el script?

1. **Configura 2 GB de swap** para compensar la RAM limitada
2. **Instala dependencias** del sistema y Python
3. **Descarga modelos** Qwen2.5-0.5B en 3 cuantizaciones:
   - `Q4_K_M` (380 MB) — mejor calidad/tamaño
   - `Q4_0` (337 MB) — más rápido
   - `Q3_K_M` (339 MB) — más pequeño
4. **Descarga binarios pre-compilados de llamafile** v0.10.3 (normal + thin/slim)
5. **Configura `--mlock`** vía `setcap` para fijar el modelo en RAM

### Salida esperada

Los binarios quedan en `/usr/local/bin/`:
- `llamafile` (305 MB) — versión cosmopolita completa
- `llamafile-thin` (43 MB) — versión slim (menos dependencias)

Los modelos quedan en `~/models/`.

## Uso

### Modo CLI

```bash
llamafile -m ~/models/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf \
  -t 4 --mlock --cli -p 'Escribe un poema corto' -n 100
```

### Modo servidor (API OpenAI-compatible)

```bash
llamafile -m ~/models/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf \
  -t 4 --mlock --server --port 8080
```

Luego desde otra terminal o navegador:

```bash
curl http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"LLaMA_CPP","messages":[{"role":"user","content":"Hola"}]}'
```

### Versión thin

```bash
llamafile-thin -m ~/models/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf \
  -t 4 --mlock --cli -p 'Hola' -n 50
```

### Flags importantes

| Flag | Descripción |
|---|---|
| `-m` | Ruta al modelo GGUF |
| `-t N` | Número de threads (usar `-t 4` en Pi) |
| `--mlock` | Fija el modelo en RAM (evita swapping) |
| `--cli` | Modo línea de comandos |
| `--server` | Modo servidor HTTP |
| `--port` | Puerto del servidor (default: 8080) |
| `-p` | Prompt de entrada |
| `-n N` | Máximo de tokens a generar |
| `-c N` | Tamaño del contexto (default: 512) |
