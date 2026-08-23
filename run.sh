#!/usr/bin/env bash
set -e

export HF_HOME="${HF_HOME:-/data/huggingface}"
mkdir -p "$HF_HOME/hub"

STT_MODEL="Systran/faster-distil-whisper-large-v3"
TTS_MODEL="speaches-ai/Kokoro-82M-v1.0-ONNX-int8"

uvicorn --factory speaches.main:create_app --host 0.0.0.0 --port 8000 &

until curl -sf http://127.0.0.1:8000/health >/dev/null 2>&1; do
  sleep 1
done

download_model() {
  local model="$1"
  local tries=5
  local wait_s=15
  for ((i = 1; i <= tries; i++)); do
    echo "Downloading model: $model (attempt $i/$tries)"
    if curl -sf -X POST "http://127.0.0.1:8000/v1/models/${model}"; then
      echo "OK: $model downloaded"
      return 0
    fi
    echo "WARN: attempt $i failed, retrying in ${wait_s}s..."
    sleep "$wait_s"
  done
  echo "ERROR: failed to download $model after $tries attempts"
  return 1
}

download_model "$STT_MODEL" || exit 1
download_model "$TTS_MODEL" || exit 1

/usr/bin/python3 -m wyoming_openai \
  --uri tcp://0.0.0.0:10300 \
  --stt-openai-url http://127.0.0.1:8000/v1 \
  --stt-models "$STT_MODEL" \
  --tts-openai-url http://127.0.0.1:8000/v1 \
  --tts-models "$TTS_MODEL" \
  --languages en de &

wait -n
