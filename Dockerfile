ARG PYTHON_VERSION=3.8
FROM python:${PYTHON_VERSION}-slim-bookworm AS build
RUN apt-get update && \
    apt-get install --no-install-suggests --no-install-recommends --yes libgl1-mesa-glx && \
    pip install --upgrade pip setuptools wheel

FROM build AS build-venv
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

FROM gcr.io/distroless/python3-debian12
ARG PYTHON_VERSION=3.8
COPY --from=build-venv /usr/local/lib/python${PYTHON_VERSION}/site-packages /usr/local/lib/python${PYTHON_VERSION}/site-packages
COPY --from=build-venv /venv /venv
COPY ./PeeplyticsAI.py /app/PeeplyticsAI.py
COPY ./best.pt /app/best.pt
WORKDIR /app
ENTRYPOINT ["PeeplyticsAI.py"]