FROM ghcr.io/speaches-ai/speaches:latest-cpu

ENV HF_HOME=/share/huggingface

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3-pip curl \
    && /usr/bin/python3 -m pip install --no-cache-dir --break-system-packages wyoming-openai \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 8000 10300
ENTRYPOINT ["/run.sh"]
