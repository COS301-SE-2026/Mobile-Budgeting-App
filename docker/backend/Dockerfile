ARG PYTHON_IMAGE=python:3.12-slim
FROM ${PYTHON_IMAGE}

WORKDIR /app

RUN pip install --no-cache-dir uv==0.5.11

COPY backend/pyproject.toml backend/uv.lock ./
RUN uv sync --frozen --no-dev

COPY backend/src ./src

ARG APP_HOST=0.0.0.0
ARG APP_PORT=8000
ENV APP_HOST=${APP_HOST}
ENV APP_PORT=${APP_PORT}

EXPOSE ${APP_PORT}

RUN useradd --create-home --shell /bin/bash appuser \
    && chown -R appuser:appuser /app
USER appuser

CMD ["sh", "-c", "uv run --no-sync uvicorn src.main:app --host ${APP_HOST} --port ${APP_PORT}"]