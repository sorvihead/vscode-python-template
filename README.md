# VS Code Python Development Template

A Python development template for VS Code that streamlines the setup process. Fork this repository and get a configured development environment quickly.

## 🎯 Purpose

This template provides a **pre-configured** Python development environment for **VS Code users**. It optimizes the configuration process - fork, run one command, and start coding with modern tooling already set up.

## ✨ What You Get

- **🚀 Streamlined setup** - One command gets you started
- **🔧 Modern tooling** - Ruff, Pyright, Pytest pre-configured  
- **🐳 Database ready** - PostgreSQL 17 with Docker/Podman
- **📝 VS Code optimized** - Launch configs and settings included
- **🤖 AI-assisted** - GitHub Copilot instructions for modern Python patterns
- **⚡ Fast dependencies** - Uses `uv` for package management
- **🐋 Production ready** - Multi-stage Docker builds included
- **☸️ Kubernetes ready** - Minikube setup with isolated profile

## 📋 Prerequisites

- **VS Code** (required)
- **Python 3.13+**
- **Container Engine** (Docker Desktop or Podman)
- **Minikube** (optional, for Kubernetes development)

### Optional Minikube Setup
For Kubernetes development, install Minikube following the [official documentation](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Farm64%2Fstable%2Fbinary+download).

**Note**: Also ensure you have a container runtime (Docker Desktop or Podman) installed before using Minikube.

## 🚀 Quick Start

1. **Fork and clone** this repository
2. **Setup environment**: `make dev-setup`
3. **Activate**: `source .venv/bin/activate`
4. **Open in VS Code**: `code .`

## 🛠️ Available Commands

### Development Setup
```bash
make dev-setup        # Complete development setup (installs system deps, uv, syncs deps, sets up postgres & vscode)
make install-system-deps  # Install PostgreSQL libraries (macOS: postgresql@17, Linux: libpq-dev)
make install-uv       # Install uv package manager if not present
make sync-deps        # Sync dependencies with uv (includes dev dependencies)
make activate-venv    # Show activation command
```

### Database Management
```bash
make setup-postgres   # Setup PostgreSQL 17 container with development database
make clean-postgres   # Stop and remove PostgreSQL container + volume
```

### VS Code Configuration
```bash
make setup-vscode     # Copy launch configurations from templates
```

### Docker Production
```bash
make docker-build     # Build production image (python-template:latest)
make docker-run       # Run production container on port 8000
make docker-stop      # Stop production container
make docker-clean     # Remove production container and image
```

### Kubernetes with Minikube
```bash
make minikube-setup   # Setup isolated Minikube cluster (profile: dev-template-env)
make helm-deploy      # Build image, load to Minikube, deploy with Helm
make minikube-status  # Check cluster status
make minikube-clean   # Clean Minikube cluster and profile
```

### Cleanup
```bash
make clean           # Clean everything (postgres + docker + .venv + vscode configs)
make minikube-clean  # Clean Minikube cluster and profile
```

## 🗄️ Database Connection

PostgreSQL container with development credentials:
- **Host**: localhost
- **Port**: 5432  
- **Database**: devdb
- **Username**: dev
- **Password**: password
- **Connection**: `postgresql://dev:password@localhost:5432/devdb`

## 🐋 Docker Commands

### Build Production Image
```bash
make docker-build
```
Builds a production-ready Docker image tagged as `python-template:latest` using multi-stage build for optimized size (~120MB).

### Run Container
```bash
make docker-run
```
Runs the container in daemon mode on port 8000. Access at http://localhost:8000

### Stop Container
```bash
make docker-stop
```
Stops the running container.

### Clean Up
```bash
make docker-clean
```
Removes container and image completely.

### Complete Docker Workflow
```bash
# Build and run
make docker-build
make docker-run

# When done
make docker-stop
make docker-clean
```

## ☸️ Minikube Development Environment

### Setup Minikube Cluster
```bash
make minikube-setup   # Setup local Kubernetes cluster with profile 'dev-template-env'
```
Creates a local Kubernetes cluster with:
- **Profile**: `dev-template-env`
- **Driver**: Podman
- **Container Runtime**: containerd
- **Memory**: 4GB RAM
- **CPUs**: 2 cores
- **Disk**: 20GB
- **Kubernetes Version**: v1.28.0
- **Addons**: ingress, auto-pause, metrics-server, dashboard

### Minikube Management
```bash
make minikube-status        # Check cluster status
make minikube-fix-kubectl   # Fix kubectl connection issues
make minikube-clean         # Delete cluster completely
```

### Deploy with Helm
```bash
make helm-deploy           # Build image, load to Minikube, and deploy with Helm
```
This command performs a complete deployment workflow:
1. **Prerequisites**: Ensures Minikube is running and Docker image is built
2. **Image Export**: Saves Docker image to tarfile
3. **Image Load**: Loads image into Minikube cluster
4. **Cleanup**: Removes temporary tarfile
5. **Helm Deploy**: Deploys application using Helm with Minikube-specific values

After deployment, access your application:
- **Get service info**: `kubectl get svc project-template`
- **Port forward**: `kubectl port-forward svc/project-template 8080:8080`
- **Access**: http://localhost:8080

### Minikube Cluster Features
- **Project Isolation**: Uses dedicated profile `dev-template-env` (isolated from other projects)
- **Auto-pause**: Automatically pauses when idle to save system resources
- **Ingress Controller**: Enabled for local web application testing
- **Metrics Server**: Available for resource monitoring
- **Dashboard**: Access via `minikube dashboard --profile=dev-template-env`
- **Smart Detection**: Script automatically detects existing profiles and their status

## 📊 Helm Chart

The project includes a simplified Helm chart for Kubernetes deployment:

### Chart Structure
```
helm/
├── Chart.yaml                    # Chart metadata
├── values.yaml                   # Default configuration
├── configs/
│   └── minikube/
│       └── values.test.yaml     # Minikube-specific overrides
└── templates/
    ├── _helpers.tpl             # Template helpers
    ├── deployment.yaml          # Application deployment
    └── service.yaml             # Service definition
```

### Key Features
- **Simplified Configuration**: Essential settings only, optimized for local development
- **Health Checks**: Process-based liveness probes (temporary, until API is implemented)
- **Resource Management**: CPU and memory limits configured
- **Local Development**: Minikube-specific values with reduced resource requirements
- **Flexible Image**: Configurable repository and tag via values

### Helm Configuration
```yaml
# Default values (values.yaml)
image:
  repository: python-template
  tag: "latest"
  pullPolicy: IfNotPresent

# Minikube overrides (configs/minikube/values.test.yaml)  
image:
  repository: localhost/python-template
  tag: "latest"
  pullPolicy: Never  # Use local images
```

### Manual Helm Commands
```bash
# Deploy manually
helm upgrade project-template helm/ \
  --install \
  --values=helm/configs/minikube/values.test.yaml

# Check status
helm status project-template

# Uninstall
helm uninstall project-template
```

### Minikube Cluster Details
- **Profile Name**: `dev-template-env`
- **Resource Allocation**: 2 CPUs, 4GB RAM, 20GB disk
- **Prerequisites**: Requires Podman (or Docker) and Minikube installed
- **Health Checks**: Automatic cluster health verification during setup

### Complete Minikube Workflow
```bash
# Setup cluster
make minikube-setup

# Check status
make minikube-status

# Build and deploy (when ready)
eval $(minikube docker-env --profile=dev-template-env)
make docker-build

# Clean up when done
make minikube-clean
```

## 📦 Adding Dependencies

Add to `pyproject.toml` and run `make sync-deps`:

```toml
dependencies = [
    "fastapi>=0.104.0",
    "psycopg[binary]>=3.1.0",
]

[dependency-groups]
dev = [
    "your-dev-tool>=1.0.0",
]
```

## 🔧 Pre-configured Tools

- **Ruff** - Linting & formatting (120 char line length)
- **Pyright** - Type checking  
- **Pytest** - Testing framework
- **uv** - Fast Python package management

## 🏗️ Project Structure

```
vscode-python-template/
├── 📄 Makefile                    # Development automation
├── 📄 pyproject.toml              # Python project config  
├── 📄 Dockerfile                  # Production container
├── 📄 .dockerignore               # Docker build exclusions
├── 📄 README.md                   # This file
├── 📁 .minikube/                  # Minikube configuration
│   └── 📄 setup-minikube.sh       # Minikube setup script
├── 📁 launch_templates/           # VS Code configurations
│   └── 📄 launch.example.json     # Debug/run configs
└── 📁 .vscode/                    # Auto-generated VS Code settings
    └── 📄 launch.json
```

## 📈 Platform Support & Updates

### Platform Support
- **Primary**: macOS (Apple Silicon) - Fully tested
- **Secondary**: Linux (Debian/Ubuntu) - Supported
- **Container**: Docker Desktop or Podman (auto-detected)

### Technology Updates
This template stays current with:
- **uv** evolution for faster Python package management
- **VS Code** and **GitHub Copilot** ecosystem improvements
- **Ruff** development as it replaces multiple tools
- **Docker** optimization and security practices

## 🚀 Usage Workflows

### Development Workflow
```bash
make dev-setup              # One-time setup
source .venv/bin/activate   # Activate environment
code .                      # Open in VS Code
# Start coding!
```

### Production Workflow  
```bash
make docker-build          # Build production image
make docker-run            # Run in container
# Test your application at http://localhost:8000
make docker-clean          # Clean up when done
```

### Full Cleanup
```bash
make clean                 # Removes everything: postgres, docker, .venv, vscode configs
```

## 🤖 GitHub Copilot Custom Instructions

This template includes **optimized GitHub Copilot custom instructions** following VS Code best practices with specialized instruction files.

### 📋 Instruction Structure

```
.github/
├── copilot-instructions.md          # Core Python 3.13+ standards
└── instructions/
    ├── ai-behavior.md               # AI interaction guidelines  
    ├── interface-design.md          # Type system and generics
    ├── logging-standards.md         # Logging and error handling
    ├── testing-standards.md         # Test patterns and pytest
    └── web-development.md           # API and architecture patterns
```

### ⚙️ How It Works

- **Automatic loading**: Instructions are automatically applied via VS Code settings
- **Specialized context**: Each file provides domain-specific knowledge 
- **Better results**: Copilot gets focused context without information overload
- **Team consistency**: Enforces modern Python patterns across all AI-generated code

### 🚀 Key Features

- **Modern Python 3.13+**: Built-in generics, `type` statements, comprehensive type hints
- **Architecture patterns**: Protocol vs ABCMeta, dependency injection, domain-driven design
- **Quality standards**: Structured logging, proper error handling, testing best practices
- **AI behavior tuning**: Skeptical questioning, fact-based responses, pragmatic solutions

### 📖 Usage

1. **Install GitHub Copilot** extension in VS Code
2. **Instructions auto-apply** - no additional setup needed
3. **Start coding** - Copilot automatically follows all instruction patterns
4. **Ask in chat** - Get context-aware responses like "create a repository class"

> 📚 **Detailed documentation**: See [`.github/instructions/README.md`](.github/instructions/README.md) for complete instruction details.

## 📄 License

MIT License

---

**Optimizes Python development setup for VS Code** 🚀

*Author: Pavel Novoidarskii (sorvihead1@gmail.com)*