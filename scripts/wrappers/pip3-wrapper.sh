#!/bin/bash

ORIG_PIP="$(dirname "$0")/$(basename "$0")-orig"

if [ ! -f "$ORIG_PIP" ]; then
    echo "Error: Original pip ($ORIG_PIP) not found. Please reinstall areq."
    exit 1
fi

# Run the original pip command
"$ORIG_PIP" "$@"
EXIT_CODE=$?

# Update requirements.txt on install or uninstall
if [ $EXIT_CODE -eq 0 ] && { [[ "$1" == "install" ]] || [[ "$1" == "uninstall" ]]; }; then
    "$ORIG_PIP" list --format=freeze | grep -v "^-e" | grep -v "^#" | grep -v "git+" | sort > requirements.txt
    echo "Updated requirements.txt with current packages."
fi

# Cleanup function for pip wrappers
cleanup_pip() {
    local cmd="$1"
    local BIN_DIR="$(dirname "$0")"
    local wrapper_path="$BIN_DIR/$cmd"
    local orig_path="$BIN_DIR/$cmd-orig"

    echo "Checking $wrapper_path"
    if [ -f "$wrapper_path" ]; then
        if grep -q "ORIG_PIP" "$wrapper_path" 2>/dev/null; then
            rm -f "$wrapper_path"
            echo "Removed wrapper: $wrapper_path"
        else
            echo "Skipping $wrapper_path - not our wrapper"
        fi
    else
        echo "No wrapper found at $wrapper_path"
    fi

    echo "Checking $orig_path"
    if [ -f "$orig_path" ]; then
        mv "$orig_path" "$wrapper_path"
        echo "Restored original: $wrapper_path from $orig_path"
    else
        echo "No original found at $orig_path"
    fi

    if [ -f "$orig_path" ]; then
        rm -f "$orig_path"
        echo "Force removed lingering original: $orig_path"
    fi
}

# If uninstalling areq, clean up wrappers and originals
if [ $EXIT_CODE -eq 0 ] && [ "$1" == "uninstall" ] && [[ "$2" == "areq" || "$3" == "areq" ]]; then
    echo "Detected uninstall of areq, running cleanup"
    cleanup_pip "pip"
    cleanup_pip "pip3"
    # Final requirements.txt update with restored pip
    if [ -f "$(dirname "$0")/pip" ]; then
        "$(dirname "$0")/pip" list --format=freeze | grep -v "^-e" | grep -v "^#" | grep -v "git+" | sort > requirements.txt
        echo "Final update to requirements.txt with restored pip"
    else
        echo "Warning: Restored pip not found, skipping final requirements.txt update"
    fi
    echo "Cleanup complete"
fi

exit $EXIT_CODE
