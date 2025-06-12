# Logging Standards

## Structured Logging Requirements

- Use structured logging with logger.error(exc_info=True) instead of logger.exception()
- Include contextual information in log messages
- Use appropriate log levels (DEBUG, INFO, WARNING, ERROR, CRITICAL)
- Include correlation IDs for request tracing
- Log errors with full exception context

## Error Handling

- Apply proper error handling with status codes
- Log errors at appropriate levels
- Include relevant context in error messages
- Use exc_info=True for exception logging
