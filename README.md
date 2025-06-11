# VS Code Python Development Template

A Python development template for VS Code that streamlines the setup process. Fork this repository and get a configured development environment quickly.

## 🎯 Purpose

This template provides a **pre-configured** Python development environment for **VS Code users**. It optimizes the configuration process - fork, run one command, and start coding with modern tooling already set up.

## ✨ What You Get

- **🚀 Streamlined setup** - One command gets you started
- **🔧 Modern tooling** - Ruff, Pyright, Pytest pre-configured  
- **🐳 Database ready** - PostgreSQL 17 with Docker
- **📝 VS Code optimized** - Launch configs and settings included
- **⚡ Fast dependencies** - Uses `uv` for package management

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

```bash
make dev-setup        # Complete setup
make sync-deps        # Update dependencies
make setup-postgres   # Setup database
make clean           # Clean everything
```

## 🗄️ Database

PostgreSQL container with development credentials:
- **Connection**: `postgresql://dev:password@localhost:5432/devdb`

## 📦 Adding Dependencies

Add to `pyproject.toml` and run `make sync-deps`:

```toml
dependencies = [
    "fastapi>=0.104.0",
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

## 📈 Project Updates & Platform Support

### Technology Updates
This template stays current with:
- **uv** evolution for faster Python package management
- **VS Code** and **GitHub Copilot** ecosystem improvements
- **Ruff** development as it replaces multiple tools
- Modern Python development practices

### Platform Support
- **Tested on**: macOS (Apple Silicon)
- **Linux support**: Planned
- **Focus**: Cross-platform compatibility in development

## 📄 License

MIT License

---

**Optimizes Python development setup for VS Code** 🚀

*Author: Pavel Novoidarskii (sorvihead1@gmail.com)*