FROM python:3.11-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

COPY pyproject.toml uv.lock README.md ./

RUN --mount=type=cache,id=s/8498400f-2692-45de-9283-1081962cb43d-root/.cache/uv,target=/root/.cache/uv \
    uv sync --frozen --no-install-project

COPY src/ ./src/
COPY .github/core/ ./.github/core/

RUN --mount=type=cache,id=s/8498400f-2692-45de-9283-1081962cb43d-root/.cache/uv,target=/root/.cache/uv \
    uv sync --frozen

ENV PATH="/app/.venv/bin:$PATH"

CMD ["alpaca-mcp-server", "--transport", "streamable-http", "--host", "0.0.0.0"]
