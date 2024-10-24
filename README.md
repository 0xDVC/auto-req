# Auto-Req

Light-weight automatic package management tool for pip. Perfect for resource-constrained environments.

## Features

- Automatically manages requirements.txt file
- Zero configuration needed
- Lightweight with no dependencies
- Works with regular pip commands
- Perfect for resource-constrained environments like Raspberry Pi and IoT projects.

## Installation (Development-mode)
- Clone repository
```
git clone https://github.com/0xDVC/auto-req.git
```

- Install in development mode
```
pip install -e .
```


## Usage
Auto-Req works as a drop-in replacement for pip. Simply use it as you would normally use pip. Regular pip commands are supported. The requirements.txt file will be automatically updated whenever you install or uninstall packages.
```
pip install <package>
```

### How It Works

Auto-Req wraps the standard pip command and:
1. Executes your pip command normally
2. If successful, updates your requirements.txt file automatically
3. Maintains exact versions for better reproducibility

### Limitations
Auto-Req won't update requirements.txt when:
- Using pip with `-r` or `--requirement` flags
- Installing from git repositories
- Installing from local files
- Using editable installs (`-e` flag)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/[name]`)
3. Run tests (`pytest`)
4. Commit changes (`git commit -m 'Add [feature]'`)
5. Push to branch (`git push origin feature/[name]`)
6. Open a Pull Request

## Testing

Run the test suite using pytest:

```bash
# Install dev dependencies
pip install -e "."

# Run tests
pytest

# Run with coverage
pytest --cov=auto_req
```

Tests are located in the `tests/` directory and follow the pytest conventions.
