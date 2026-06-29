ARG PYTHON_IMAGE=python:3.12-slim
FROM ${PYTHON_IMAGE}

WORKDIR /app

RUN pip install --no-cache-dir uv

COPY backend/pyproject.toml backend/uv.lock ./
RUN uv sync --frozen --no-dev

COPY backend/src ./src

ARG APP_HOST=0.0.0.0
ARG APP_PORT=8000

EXPOSE ${APP_PORT}

CMD ["sh", "-c", "uv run uvicorn src.main:app --host ${APP_HOST} --port ${APP_PORT}"]
