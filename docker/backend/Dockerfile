FROM python:3.12-slim

WORKDIR /app

RUN pip install --no-cache-dir uv

COPY backend/pyproject.toml backend/uv.lock ./
RUN uv sync --frozen --no-dev

COPY backend/src ./src

EXPOSE 8000

CMD ["uv" , "run" , "uvicorn" , "src.main:app" , "--host" , "0.0.0.0" , "--port" , "8000"]
