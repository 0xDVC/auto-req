#!/bin/bash

# check if pip is installed
if ! command -v pip && ! command -v pip3; then
    echo "Error: pip or pip3 not found. Install Python and pip first."
    exit 1
fi

# uninstall
if [ "$1" = "uninstall" ]; then
    echo "Uninstalling areq..."
    pip uninstall areq -y || pip3 uninstall areq -y
    WRAPPER_DIR="$HOME/.local/bin"
    if [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    else
        SHELL_CONFIG="$HOME/.bashrc"
    fi
    for cmd in pip pip3; do
        WRAPPER_PATH="$WRAPPER_DIR/$cmd-wrapper.sh"
        if [ -f "$WRAPPER_PATH" ]; then
            rm "$WRAPPER_PATH"
            echo "Removed $cmd wrapper"
        fi
        if grep -q "alias $cmd=" "$SHELL_CONFIG"; then
            sed -i.bak "/alias $cmd=/d" "$SHELL_CONFIG"
            echo "Removed $cmd alias from $SHELL_CONFIG"
        fi
    done
    echo "areq uninstalled"
    exit 0
fi

# python version heck
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))' || python -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
if [ "$(echo -e "3.6\n$PYTHON_VERSION" | sort -V | head -n1)" != "3.6" ]; then
    echo "Error: Python 3.6+ needed, got $PYTHON_VERSION"
    exit 1
fi

# Install areq from GitHub
echo "Installing areq from GitHub..."
pip install git+https://github.com/0xdvc/auto-req.git --user || pip3 install git+https://github.com/0xdvc/auto-req.git --user
if [ $? -ne 0 ]; then
    echo "Install failed. Check network or pip setup."
    exit 1
fi

# set up wrappers and aliases
WRAPPER_DIR="$HOME/.local/bin"
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
else
    SHELL_CONFIG="$HOME/.bashrc"
fi
for cmd in pip pip3; do
    if ! grep "alias $cmd=" "$SHELL_CONFIG"; then
        echo "alias $cmd='$WRAPPER_DIR/$cmd-wrapper.sh'" >> "$SHELL_CONFIG"
        echo "Added $cmd alias to $SHELL_CONFIG"
    else
        echo "$cmd alias already exists in $SHELL_CONFIG"
    fi
done
echo "Run 'source $SHELL_CONFIG' to apply changes"

echo "areq installed. It’ll auto-sync requirements.txt when you use pip or pip3."
echo "To uninstall: $0 uninstall"
