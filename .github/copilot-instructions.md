# Python Development Instructions

This project uses Python 3.13+ with modern syntax and comprehensive type hints.

## Core Standards

- Use Python 3.13+ syntax with built-in generics and `type` statements
- Add comprehensive type hints to all functions, methods, and class attributes
- Use built-in types (list, dict, tuple) instead of importing from typing
- Import from typing when needed for types not available as built-ins
- Follow PEP 8 style guide strictly

## Function Guidelines

- Keep functions under 40 lines
- Use clear, descriptive names
- Include comprehensive docstrings with Args, Returns, Raises
- Add type hints to all parameters and return values
- Use pattern matching for complex conditionals
- Prefer comprehensions over for-loops when appropriate

## Code Organization

- Follow Ruff import organization rules
- Use __init__.py to define package APIs
- Define __all__ for public modules
- Use __main__.py for executable modules
- Add docstrings to all public functions and classes

## Available VS Code Tasks

- **Ruff check**: Linting with auto-fix
- **Ruff format**: Code formatting  
- **Pyright check**: Type checking
- All tasks available via VS Code Command Palette