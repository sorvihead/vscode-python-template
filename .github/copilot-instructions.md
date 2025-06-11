# Python Web Development Template Instructions

You are working on a modern Python web development project. Follow these coding standards and practices consistently.

## Project Standards

Use Python 3.13+ features and modern syntax.
Follow PEP 8 style guide strictly.
Use uv for dependency management instead of pip.
Apply Ruff for linting and formatting.
Use Pyright for type checking.
Write tests with pytest.

## Type Annotations

Use built-in types for Python 3.11+ without importing from typing.
Import from typing only for complex types like Any, Iterable, Protocol.
Add type hints to all functions, methods, and class attributes.
Don't add type hints to simple variables unless the type is unclear.

## TypeVars

Use Python 3.13+ generic syntax without importing TypeVar.
Use the new `type` statement for type aliases and generic type definitions.
Apply proper bounds and constraints using modern syntax.

## Decorators

Add type hints to every decorator function.
Use proper generic typing for decorators that preserve function signatures.
Apply appropriate return type annotations for decorated functions.

## Interfaces and Abstract Classes

Use typing.Protocol instead of abc if it's an interface without state and base behavior.
Use metaclass=ABCMeta instead of ABC if it's a base class with state and/or base behavior. Base methods should be covered with abstractmethod decorator.

## Error Handling

Use logger.error() with exc_info=True instead of logger.exception().
Prefer specific exception types over generic Exception.
Always log errors with meaningful context.
Use logger instead of print for output and debugging.

## Modern Python Features

Use pattern matching for complex conditionals and sum types.
Omit case _ when all cases are explicitly covered.
Prefer match statements over long if-elif chains.
Use dataclasses or Pydantic for data structures.

## Code Organization

Use clear, descriptive function and variable names.
Keep functions small and focused on single responsibility.
Organize imports: standard library, third-party, local.
Add docstrings to all public APIs.
Use __init__.py files to define package structure.
Use __main__.py for executable modules.
Define __all__ to specify public module APIs.

## Web Development Patterns

Follow RESTful API design principles.
Use Pydantic models for data validation.
Apply security best practices for web applications.
Use domain-driven design principles for data modeling.
When generating code, always include type hints for functions and methods, use modern Python syntax, handle errors appropriately with logging, follow existing project patterns, and keep code readable and maintainable.