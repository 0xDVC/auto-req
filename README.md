# Auto-Req

Light-weight automatic package management tool for pip. Perfect for resource-constrained environments.

## Features

- Automatically manages requirements.txt file
- Zero configuration needed
- Lightweight with no dependencies
- Works with regular pip commands
- Perfect for resource-constrained environments like Raspberry Pi and IoT projects.

## Installation
```
pip install auto-req
```

## Usage
Auto-Req works as a drop-in replacement for pip. Simply use it as you would normally use pip. Regular pip commands are supported. The requirements.txt file will be automatically updated whenever you install or uninstall packages.

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