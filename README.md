# Speaches (Kokoro TTS + Whisper STT) — Home Assistant Add-on

A local Home Assistant add-on (Docker image) that runs [Speaches](https://github.com/speaches-ai/speaches), a self-hosted speech server with an OpenAI-compatible API, and exposes it to Home Assistant:

- **TTS** — [Kokoro-82M](https://huggingface.co/speaches-ai/Kokoro-82M-v1.0-ONNX-int8) (high-quality, fast, CPU-friendly)
- **STT** — [faster-distil-whisper-large-v3](https://huggingface.co/Systran/faster-distil-whisper-large-v3) (speech-to-text)

Both are usable natively in Home Assistant via the **Wyoming protocol** on port `10300` — in Assist pipelines, voice satellites, `tts.speak`, etc.

## How it works

Speaches itself speaks an OpenAI-compatible HTTP API, not Wyoming. This add-on bundles [wyoming-openai](https://github.com/roryeckel/wyoming_openai), a bridge that translates the Wyoming protocol (which Home Assistant speaks natively) to the OpenAI-compatible endpoints:

```
Home Assistant  ──Wyoming──  wyoming-openai (port 10300)  ──OpenAI HTTP──  speaches (port 8000)
```

On startup, `run.sh`:

1. Starts the Speaches server (model download API on port 8000)
2. Triggers the download of the STT and TTS models (with retries) into `/share/huggingface`, where they persist across add-on rebuilds
3. Starts the `wyoming-openai` bridge on port 10300

## Installation

1. Copy this folder to the `/addons/` directory of your Home Assistant instance (via Samba, SSH, or the Studio Code Server add-on).
2. In Home Assistant: **Settings → Add-ons → Local Add-ons** (or the add-on store's ⋮ menu → **Reload**), then install and start **Speaches (Kokoro)**.
3. On first start, both models are downloaded (several GB) — watch the add-on logs until you see the bridge come up. Downloads persist in `/share/huggingface`.

## Home Assistant integration

Add the [Wyoming Protocol integration](https://www.home-assistant.io/integrations/wyoming):

1. **Settings → Devices & Services → Add Integration → Wyoming Protocol**
2. Enter your Home Assistant host's LAN address (e.g. `homeassistant.local` or `192.168.x.x`) and port **`10300`**
3. Both an STT and a TTS entity appear — select them in your Assist pipeline (Settings → Voice assistants).

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 8000 | HTTP | Speaches OpenAI-compatible API (debugging / direct use) |
| 10300 | Wyoming | Home Assistant STT + TTS integration |

## Changing models

Edit `STT_MODEL` / `TTS_MODEL` at the top of `run.sh` to use other [Speaches-supported models](https://github.com/speaches-ai/speaches) (e.g. different Whisper variants), then rebuild the add-on.
