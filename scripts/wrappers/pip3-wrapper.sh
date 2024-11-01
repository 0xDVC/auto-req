#!/bin/bash

# Check if pip is installed
if ! command -v pip && ! command -v pip3; then
    echo "Error: pip or pip3 not found. Install Python and pip first."
    exit 1
fi

# Uninstall if requested
if [ "$1" = "uninstall" ]; then
    echo "Uninstalling areq..."
    pip uninstall areq -y || pip3 uninstall areq -y
    # Detect virtual env
    if [ -n "$VIRTUAL_ENV" ]; then
        WRAPPER_DIR="$VIRTUAL_ENV/bin"
    else
        WRAPPER_DIR="$HOME/.local/bin"
    fi
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    else
        SHELL_CONFIG="$HOME/.bashrc"
    fi
    for cmd in pip pip3; do
        WRAPPER_PATH="$WRAPPER_DIR/areq-$cmd-wrapper.sh"
        if [ -f "$WRAPPER_PATH" ]; then
            rm "$WRAPPER_PATH"
            echo "Removed $cmd wrapper"
        fi
        if [ -f "$SHELL_CONFIG" ] && grep -q "alias $cmd=" "$SHELL_CONFIG"; then
            sed -i.bak "/alias $cmd=/d" "$SHELL_CONFIG"
            echo "Removed $cmd alias from $SHELL_CONFIG"
        fi
    done
    echo "areq uninstalled"
    exit 0
fi

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' || python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
if [ "$(echo -e "3.6\n$PYTHON_VERSION" | sort -V | head -n1)" != "3.6" ]; then
    echo "Error: Python 3.6+ needed, got $PYTHON_VERSION"
    exit 1
fi

# Install areq from GitHub, adjust for virtual env
echo "Installing areq from GitHub..."
if [ -n "$VIRTUAL_ENV" ]; then
    pip install git+https://github.com/0xdvc/auto-req.git || pip3 install git+https://github.com/0xdvc/auto-req.git
else
    pip install git+https://github.com/0xdvc/auto-req.git --user || pip3 install git+https://github.com/0xdvc/auto-req.git --user
fi
if [ $? -ne 0 ]; then
    echo "Install failed. Check network or pip setup."
    exit 1
fi

# Set up wrappers and aliases
if [ -n "$VIRTUAL_ENV" ]; then
    WRAPPER_DIR="$VIRTUAL_ENV/bin"
else
    WRAPPER_DIR="$HOME/.local/bin"
fi
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
else
    SHELL_CONFIG="$HOME/.bashrc"
fi
for cmd in pip pip3; do
    if ! grep "alias $cmd=" "$SHELL_CONFIG"; then
        echo "alias $cmd='$WRAPPER_DIR/areq-$cmd-wrapper.sh'" >> "$SHELL_CONFIG"
        echo "Added $cmd alias to $SHELL_CONFIG"
    else
        echo "$cmd alias already exists in $SHELL_CONFIG"
    fi
done
echo "Run 'source $SHELL_CONFIG' to apply changes"

echo "areq installed. It’ll auto-sync requirements.txt when you use pip or pip3."
echo "To uninstall: bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/0xdvc/auto-req/main/install.sh)\" uninstall"
