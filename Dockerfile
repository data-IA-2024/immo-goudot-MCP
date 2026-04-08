# Version compatible avec l'ancien builder (sans --mount)
FROM ghcr.io/astral-sh/uv:bookworm-slim AS builder
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy
ENV UV_NO_DEV=1
ENV UV_PYTHON_INSTALL_DIR=/python
ENV UV_PYTHON_PREFERENCE=only-managed

# Install Python
RUN uv python install 3.10

WORKDIR /app

# Copier les fichiers de dépendances (pas de --mount)
COPY pyproject.toml uv.lock* ./

# Installer les dépendances
RUN uv sync --locked --no-install-project --no-dev

# Copier le code source
COPY . .

# Installer le projet
RUN uv sync --locked --no-dev

# Image finale
FROM debian:bookworm-slim

# Créer un utilisateur non-root
RUN groupadd --system --gid 999 nonroot \
 && useradd --system --gid 999 --uid 999 --create-home nonroot

# Copier Python depuis le builder
COPY --from=builder /python /python

# Copier l'application
COPY --from=builder --chown=nonroot:nonroot /app /app

# Variables d'environnement
ENV PATH="/app/.venv/bin:$PATH" \
    PYTHONUNBUFFERED=1 \
    VIRTUAL_ENV="/app/.venv" \
    UV_PYTHON="/python/bin/python3.10"

USER nonroot
WORKDIR /app

# Run the application
CMD ["fastmcp", "run", "main.py:mcp", "--transport", "http", "--port", "8000", "--host", "0.0.0.0"]