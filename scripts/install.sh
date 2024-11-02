#!/bin/bash

# check if pip is installed
if ! command -v pip3 >/dev/null 2>&1 && ! command -v pip >/dev/null 2>&1; then
    echo "Error: pip or pip3 not found. Install Python and pip first."
    exit 1
fi

# use pip3 if unavailable (mostly the case)
PIP_CMD=$(command -v pip3 || command -v pip)

# check for py's version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null || python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' 2>/dev/null)
if [ -z "$PYTHON_VERSION" ] || [ "$(echo -e "3.6\n$PYTHON_VERSION" | sort -V | head -n1)" != "3.6" ]; then
    echo "Error: Python 3.6+ required, got $PYTHON_VERSION or no Python found"
    exit 1
fi

# install areq
echo "Installing areq from GitHub..."
if [ -n "$VIRTUAL_ENV" ]; then
    "$PIP_CMD" install git+https://github.com/0xdvc/auto-req.git
else
    "$PIP_CMD" install git+https://github.com/0xdvc/auto-req.git --user
fi
if [ $? -ne 0 ]; then
    echo "Install failed. Check network, pip setup, or GitHub availability."
    exit 1
fi

# set up alias
if [ -n "$VIRTUAL_ENV" ]; then
    WRAPPER_DIR="$VIRTUAL_ENV/bin"
else
    WRAPPER_DIR="$HOME/.local/bin"
fi
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    SHELL_CONFIG="$HOME/.profile"  # potential fallbacks to default shell config
fi
for cmd in pip pip3; do
    WRAPPER_PATH="$WRAPPER_DIR/$cmd"
    if [ -f "$WRAPPER_PATH" ]; then
        if ! grep -q "alias $cmd=" "$SHELL_CONFIG" 2>/dev/null; then
            echo "alias $cmd='$WRAPPER_PATH'" >> "$SHELL_CONFIG"
            echo "Added $cmd alias to $SHELL_CONFIG"
        else
            echo "$cmd alias already exists in $SHELL_CONFIG"
        fi
    else
        echo "Warning: $WRAPPER_PATH not found, alias not set"
    fi
done
echo "Run 'source $SHELL_CONFIG' to apply aliases now, or restart your shell."

echo "areq installed! It auto-syncs requirements.txt when you use pip or pip3."
echo "To uninstall: 'pip uninstall areq'"
