ARG PYTHON_IMAGE=python:3.12-slim
FROM ${PYTHON_IMAGE}

WORKDIR /app

RUN pip install --only-binary :all: --no-cache-dir uv==0.5.11

COPY backend/pyproject.toml backend/uv.lock ./
RUN uv sync  --frozen --no-dev  

COPY backend/src ./src

ARG APP_HOST=0.0.0.0
ARG APP_PORT=8000
ENV APP_HOST=${APP_HOST}
ENV APP_PORT=${APP_PORT}

# Number of uvicorn worker processes. Defaults to 1 (single process).
# Raise it (e.g. 2-4) if a large sync blocks other requests, but be aware each
# worker runs its own event loop + connection pool, so more workers use more
# memory and more Postgres connections.
ARG UVICORN_WORKERS=1
ENV UVICORN_WORKERS=${UVICORN_WORKERS}

EXPOSE ${APP_PORT}

ENV PYTHONPATH=/app/src

RUN useradd --create-home --shell /bin/bash appuser \
    && chown -R appuser:appuser /app
USER appuser

CMD ["sh", "-c", "uv run --no-sync uvicorn main:app --host ${APP_HOST} --port ${APP_PORT} --workers ${UVICORN_WORKERS}"]