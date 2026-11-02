# Speaches (Kokoro) — Home Assistant add-on repository

This repository provides the **Speaches (Kokoro)** Home Assistant add-on. It
runs [Speaches](https://github.com/speaches-ai/speaches) locally with
Kokoro TTS and Whisper STT, exposing both the OpenAI-compatible HTTP API and
the Wyoming protocol.

## Installation

1. In Home Assistant, open **Settings → Apps → App repositories**.
2. Add this repository URL:

   ```text
   https://github.com/Chalkin/speaches-tts-ha
   ```

3. Refresh the app store, open **Speaches (Kokoro)**, then install and start
   it.
4. The first start downloads the configured models, which can take several
   minutes and several GB. Follow the app logs until the Wyoming bridge is
   ready.

Existing manual installations copied into `/addons` are not migrated
automatically. Remove the local copy and install this repository version when
ready to switch.

## Home Assistant integration

Add the [Wyoming Protocol integration](https://www.home-assistant.io/integrations/wyoming/)
with your Home Assistant host address and port `10300`. The add-on exposes
both STT and TTS entities for Assist pipelines.

For add-on configuration, ports, model selection and implementation details,
see [the add-on README](speaches_local/README.md).
