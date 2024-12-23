ARG DEV_FLAG="no-dev"

FROM --platform=linux/amd64 python:3.11-alpine

USER root

ADD pyproject.toml uv.lock ./

RUN pip install --upgrade uv \
    && UV_PROJECT_ENVIRONMENT=/usr/local uv sync --frozen --no-install-project --${DEV_FLAG}

ADD . .

ENV PYTHONPATH="${PYTHONPATH}:src"
