.PHONY: dev-setup install-system-deps install-uv sync-deps activate-venv setup-postgres setup-vscode minikube-setup minikube-clean minikube-status clean clean-postgres docker-build docker-run docker-stop docker-clean

# Main development setup target
dev-setup: install-system-deps install-uv sync-deps setup-postgres setup-vscode
	@echo "Development environment setup complete!"
	@echo "To activate the virtual environment, run: source .venv/bin/activate"

# Install system dependencies for psycopg
install-system-deps:
	@echo "Installing system dependencies..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "Detected macOS"; \
		echo "Installing PostgreSQL (includes libpq)..."; \
		brew install postgresql@17; \
	elif [ "$$(uname)" = "Linux" ]; then \
		echo "Detected Linux"; \
		if command -v apt-get >/dev/null 2>&1; then \
			echo "Using apt (Debian/Ubuntu)"; \
			sudo apt-get update; \
			sudo apt-get install -y libpq-dev python3-dev build-essential; \
		else \
			echo "Warning: Only Debian/Ubuntu supported. Please install libpq-dev manually."; \
		fi; \
	else \
		echo "Warning: Only macOS and Debian/Ubuntu supported."; \
	fi

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
	@if [ -f "./launch_templates/launch.example.json" ]; then \
		cp ./launch_templates/launch.example.json .vscode/launch.json; \
		echo "Copied launch configuration to .vscode/launch.json"; \
	else \
		echo "Warning: ./launch_templates/launch.example.json not found"; \
	fi

# Docker targets
docker-build:
	@echo "Building Docker image..."
	@if command -v podman >/dev/null 2>&1; then \
		echo "Using podman"; \
		podman build -t python-template:latest .; \
	elif command -v docker >/dev/null 2>&1; then \
		echo "Using docker"; \
		docker build -t python-template:latest .; \
	else \
		echo "Error: Neither podman nor docker found. Please install one of them."; \
		exit 1; \
	fi

docker-run:
	@echo "Running Docker container..."
	@if command -v podman >/dev/null 2>&1; then \
		echo "Using podman"; \
		podman run -d --name python-template-app -p 8000:8000 python-template:latest; \
	elif command -v docker >/dev/null 2>&1; then \
		echo "Using docker"; \
		docker run -d --name python-template-app -p 8000:8000 python-template:latest; \
	else \
		echo "Error: Neither podman nor docker found. Please install one of them."; \
		exit 1; \
	fi
	@echo "Container started. Access at http://localhost:8000"

docker-stop:
	@echo "Stopping Docker container..."
	@if command -v podman >/dev/null 2>&1; then \
		echo "Using podman"; \
		podman stop python-template-app 2>/dev/null || true; \
	elif command -v docker >/dev/null 2>&1; then \
		echo "Using docker"; \
		docker stop python-template-app 2>/dev/null || true; \
	else \
		echo "Error: Neither podman nor docker found."; \
		exit 1; \
	fi

docker-clean:
	@echo "Cleaning Docker containers and images..."
	@if command -v podman >/dev/null 2>&1; then \
		echo "Using podman"; \
		podman stop python-template-app 2>/dev/null || true; \
		podman rm python-template-app 2>/dev/null || true; \
		podman rmi python-template:latest 2>/dev/null || true; \
	elif command -v docker >/dev/null 2>&1; then \
		echo "Using docker"; \
		docker stop python-template-app 2>/dev/null || true; \
		docker rm python-template-app 2>/dev/null || true; \
		docker rmi python-template:latest 2>/dev/null || true; \
	else \
		echo "Error: Neither podman nor docker found."; \
		exit 1; \
	fi
	@echo "Docker cleanup complete!"

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
clean: clean-postgres docker-clean
	@echo "Cleaning up development environment..."
	@rm -rf .venv
	@rm -f .vscode/launch.json

# Minikube targets
minikube-setup:
	@echo "Setting up Minikube development environment..."
	@./.minikube/setup-minikube.sh

minikube-status:
	@echo "Checking Minikube status..."
	@./.minikube/setup-minikube.sh status

minikube-clean:
	@echo "Cleaning up Minikube environment..."
	@if command -v minikube >/dev/null 2>&1; then \
		profile_exists=$$(minikube profile list 2>/dev/null | grep -c "dev-template-env" || echo "0"); \
		if [ "$$profile_exists" -gt 0 ]; then \
			echo "Stopping and deleting profile 'dev-template-env'..."; \
			minikube stop --profile=dev-template-env 2>/dev/null || true; \
			minikube delete --profile=dev-template-env 2>/dev/null || true; \
			echo "Minikube profile 'dev-template-env' removed"; \
		else \
			echo "Profile 'dev-template-env' does not exist"; \
		fi \
	else \
		echo "Minikube not found"; \
	fi