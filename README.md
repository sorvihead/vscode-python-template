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

## 📋 Prerequisites

- **VS Code** (required)
- **Python 3.13+**
- **Container Engine** (Docker Desktop or Podman)

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

### Cleanup
```bash
make clean           # Clean everything (postgres + docker + .venv + vscode configs)
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

## 📄 License

MIT License

---

**Optimizes Python development setup for VS Code** 🚀

*Author: Pavel Novoidarskii (sorvihead1@gmail.com)*