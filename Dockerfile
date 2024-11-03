ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}-slim-bookworm AS base

FROM base AS build-env
RUN pip install --upgrade pip setuptools wheel
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

FROM base AS runner
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes libgl1-mesa-glx libglib2.0-0
COPY ./PeeplyticsAI.py /app/PeeplyticsAI.py
COPY ./best.pt /app/best.pt
WORKDIR /app
ENTRYPOINT ["python3", "PeeplyticsAI.py"]