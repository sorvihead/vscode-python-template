FROM python:3.13-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install system dependencies and clean up in one layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq5 && \
    rm -rf /var/lib/apt/lists/*

# Copy uv and uvx from official image
COPY --from=ghcr.io/astral-sh/uv:0.7.12 /uv /uvx /bin/

# Create non-root user for security
RUN useradd --create-home --shell /bin/bash app

# Set work directory
WORKDIR /app

# Copy project configuration files
COPY pyproject.toml uv.lock* ./

# Install dependencies
RUN uv lock --check && uv sync --frozen --no-dev --no-install-project

# Copy application code
COPY . .

# Change ownership to app user
RUN chown -R app:app /app

# Switch to non-root user
USER app

# Expose port
EXPOSE 8000

# Template command - replace with your application
CMD ["/bin/bash", "-c", "sleep infinity"]