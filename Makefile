.PHONY: dev-setup install-uv sync-deps activate-venv setup-postgres setup-vscode clean clean-postgres

# Main development setup target
dev-setup: install-uv sync-deps setup-postgres setup-vscode
	@echo "Development environment setup complete!"
	@echo "To activate the virtual environment, run: source .venv/bin/activate"

# Install uv if it doesn't exist
install-uv:
	@if ! command -v uv >/dev/null 2>&1; then \
		echo "Installing uv..."; \
		curl -LsSf https://astral.sh/uv/install.sh | sh; \
		export PATH="$$HOME/.cargo/bin:$$PATH"; \
	else \
		echo "uv is already installed"; \
	fi

# Sync dependencies with uv
sync-deps:
	@echo "Syncing dependencies..."
	uv sync --dev

# Activate virtual environment (note: this creates a subshell)
activate-venv:
	@echo "To activate virtual environment, run: source .venv/bin/activate"

# Setup PostgreSQL with Podman/Docker
setup-postgres:
	@echo "Setting up PostgreSQL with container engine..."
	@if command -v podman >/dev/null 2>&1; then \
		echo "Using podman"; \
		CONTAINER_CMD=podman; \
	elif command -v docker >/dev/null 2>&1; then \
		echo "Using docker"; \
		CONTAINER_CMD=docker; \
	else \
		echo "Error: Neither podman nor docker found. Please install one of them."; \
		exit 1; \
	fi; \
	$$CONTAINER_CMD volume create postgres-dev-data 2>/dev/null || true; \
	if ! $$CONTAINER_CMD images | grep -q "postgres.*17"; then \
		echo "Pulling PostgreSQL 17..."; \
		$$CONTAINER_CMD pull postgres:17; \
	else \
		echo "PostgreSQL 17 image already exists"; \
	fi; \
	if ! $$CONTAINER_CMD ps | grep -q "postgres-dev"; then \
		if $$CONTAINER_CMD ps -a | grep -q "postgres-dev"; then \
			echo "Starting existing PostgreSQL container..."; \
			$$CONTAINER_CMD start postgres-dev; \
		else \
			echo "Creating and starting PostgreSQL container..."; \
			$$CONTAINER_CMD run -d \
				--name postgres-dev \
				-e POSTGRES_PASSWORD=password \
				-e POSTGRES_USER=dev \
				-e POSTGRES_DB=devdb \
				-p 5432:5432 \
				-v postgres-dev-data:/var/lib/postgresql/data \
				postgres:17; \
		fi \
	else \
		echo "PostgreSQL container is already running"; \
	fi

# Setup VS Code configuration
setup-vscode:
	@echo "Setting up VS Code configuration..."
	@mkdir -p .vscode
	@if [ -f "./.launch_templates/launch.example.json" ]; then \
		cp ./.launch_templates/launch.example.json .vscode/launch.json; \
		echo "Copied launch configuration to .vscode/launch.json"; \
	else \
		echo "Warning: ./.launch_templates/launch.example.json not found"; \
	fi

# Stop and remove PostgreSQL container
clean-postgres:
	@echo "Stopping and removing PostgreSQL container..."
	@if command -v podman >/dev/null 2>&1; then \
		echo "Using podman"; \
		CONTAINER_CMD=podman; \
	elif command -v docker >/dev/null 2>&1; then \
		echo "Using docker"; \
		CONTAINER_CMD=docker; \
	else \
		echo "Error: Neither podman nor docker found."; \
		exit 1; \
	fi; \
	$$CONTAINER_CMD stop postgres-dev 2>/dev/null || true; \
	$$CONTAINER_CMD rm postgres-dev 2>/dev/null || true; \
	$$CONTAINER_CMD volume rm postgres-dev-data 2>/dev/null || true

# Clean up everything
clean: clean-postgres
	@echo "Cleaning up development environment..."
	@rm -rf .venv
	@rm -f .vscode/launch.json