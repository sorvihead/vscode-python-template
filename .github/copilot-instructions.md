<!-- filepath: /Users/pavelnovojdarskij/Projects/python/vscode-python-template/.github/copilot-instructions.md -->
# Python Development Instructions

Generate modern Python 3.13+ code following these standards:

## Core Requirements

- Use Python 3.13+ syntax with built-in generics and `type` statements
- Add comprehensive type hints to all functions, methods, and class attributes
- Use built-in types (list, dict, tuple) instead of importing from typing
- Import from typing when needed for types not available as built-ins
- Follow PEP 8 style guide strictly
- Use structured logging with logger.error(exc_info=True) instead of logger.exception()

## Type System

### Modern Generic Syntax
- Use type statement for aliases: `type ResponseDict[T] = dict[str, T]`
- Use generic classes with bounds: `class Repository[T: BaseModel]:`
- Avoid legacy TypeVar imports

### Interface Design
- Use Protocol for pure interfaces without state
- Use ABCMeta for base classes with state/behavior
- Mark abstract methods with @abstractmethod

### Decorator Type Hints
- Add type hints to every decorator function
- Use proper generic typing for decorators that preserve function signatures
- Apply appropriate return type annotations for decorated functions

## Function Guidelines

- Keep functions under 40 lines
- Use clear, descriptive names
- Include comprehensive docstrings with Args, Returns, Raises
- Add type hints to all parameters and return values
- Use pattern matching for complex conditionals
- Prefer comprehensions over for-loops when appropriate

## Code Organization

### Import Order
- Follow Ruff import organization rules

### Package Structure
- Use __init__.py to define package APIs
- Define __all__ for public modules
- Use __main__.py for executable modules
- Add docstrings to all public functions and classes

## Web Development Patterns

- Use Pydantic models for data validation
- Implement repository pattern for data access
- Follow domain-driven design principles
- Apply proper error handling with status codes
- Implement dependency injection for services

## Testing

- Write tests with pytest
- Use fixtures for test data
- Include integration tests for critical paths
- Maintain high test coverage
- Test error conditions and edge cases

## AI Assistant Behavior

- Be more skeptical and ask clarifying questions before generating code
- When requirements are unclear or incomplete, ask for specific details
- Suggest multiple approaches when appropriate and explain trade-offs
- Question assumptions and propose better alternatives when relevant
- Always verify understanding of the task before proceeding

## Available VS Code Tasks

When suggesting development workflows, reference these configured tasks:
- **Ruff check**: Linting with auto-fix
- **Ruff format**: Code formatting
- **Pyright check**: Type checking
- All tasks are available via VS Code Command Palette or terminal

When generating code, always include type hints, use modern Python syntax, handle errors with logging, and follow these architectural patterns.