FROM python:3.11-slim
RUN apt-get update && apt-get install -y \
    jq \
    curl \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir elasticsearch progressbar2 termcolor evtx tqdm urllib3
COPY install-datasets.sh /
WORKDIR /datasets
ENTRYPOINT ["/install-datasets.sh"]
