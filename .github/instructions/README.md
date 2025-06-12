# Copilot Instructions Structure

This project follows VS Code custom instructions best practices with specialized instruction files.

## File Structure

```
.github/
├── copilot-instructions.md          # Main general Python standards
└── instructions/
    ├── ai-behavior.md               # AI assistant interaction guidelines  
    ├── interface-design.md          # Type system and interface patterns
    ├── logging-standards.md         # Logging and error handling
    ├── testing-standards.md         # Test patterns and standards
    └── web-development.md           # Web architecture patterns
```

## How It Works

- **Main file** (`.github/copilot-instructions.md`): Contains core Python 3.13+ standards
- **Specialized files**: Domain-specific coding standards automatically loaded by Copilot
- **VS Code integration**: Configured via `github.copilot.chat.codeGeneration.instructions`

## Benefits

- **Focused context**: Each file contains specific domain knowledge
- **Better results**: Copilot gets relevant context without information overload  
- **Maintainable**: Easy to update specific areas without affecting others
- **Team consistency**: Specialized standards for different development areas
