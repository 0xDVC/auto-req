#!/bin/bash
# scripts/wrappers/pip3-wrapper.sh

ORIG_PIP="$(dirname "$0")/$(basename "$0")-orig"

if [ ! -f "$ORIG_PIP" ]; then
    echo "Error: Original pip ($ORIG_PIP) not found. Please reinstall areq."
    exit 1
fi

# run the original pip command
"$ORIG_PIP" "$@"
EXIT_CODE=$?

# update requirements.txt on install or uninstall
if [ $EXIT_CODE -eq 0 ] && { [[ "$1" == "install" ]] || [[ "$1" == "uninstall" ]]; }; then
    "$ORIG_PIP" list --format=freeze | grep -v "^-e" | grep -v "^#" | grep -v "git+" | sort > requirements.txt
fi

# cleanup function for pip wrappers
cleanup_pip() {
    local cmd="$1"
    local BIN_DIR="$(dirname "$0")"
    local wrapper_path="$BIN_DIR/$cmd"
    local orig_path="$BIN_DIR/$cmd-orig"

    if [ -f "$wrapper_path" ]; then
        if grep -q "ORIG_PIP" "$wrapper_path" 2>/dev/null; then
            rm -f "$wrapper_path"
        fi
    fi

    echo "Checking $orig_path"
    if [ -f "$orig_path" ]; then
        mv "$orig_path" "$wrapper_path"
    fi

    if [ -f "$orig_path" ]; then
        rm -f "$orig_path"
    fi
}

# when uninstalling areq, clean up wrappers and originals
if [ $EXIT_CODE -eq 0 ] && [ "$1" == "uninstall" ] && [[ "$2" == "areq" || "$3" == "areq" ]]; then
    cleanup_pip "pip"
    cleanup_pip "pip3"
    if [ -f "$(dirname "$0")/pip" ]; then
        "$(dirname "$0")/pip" list --format=freeze | grep -v "^-e" | grep -v "^#" | grep -v "git+" | sort > requirements.txt
    fi
fi

exit $EXIT_CODE
