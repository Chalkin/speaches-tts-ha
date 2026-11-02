# Changelog

## 1.0.4

- Added retry logic (5 attempts) for model downloads on first start
- Models persist in `/share/huggingface` — no re-download after add-on rebuilds

## 1.0.3

- Added STT support via `Systran/faster-distil-whisper-large-v3`

## 1.0.2

- Integrated [wyoming-openai](https://github.com/roryeckel/wyoming_openai) bridge on port 10300 for native Home Assistant integration (Wyoming protocol)

## 1.0.1

- Set `HF_HOME=/share/huggingface` so model weights are stored outside the container layer

## 1.0.0

- Initial release: Speaches server with Kokoro-82M TTS (`speaches-ai/Kokoro-82M-v1.0-ONNX-int8`) via OpenAI-compatible API on port 8000
