#!/bin/bash

# determine if we're running as pip or pip3 based on the script name
SCRIPT_NAME=$(basename "$0")
if [ "$SCRIPT_NAME" = "pip" ]; then
    ORIG_NAME="pip-orig"
else
    ORIG_NAME="pip3-orig"

SCRIPT_DIR="$(dirname "$0")"
PIP="$SCRIPT_DIR/$ORIG_NAME"

# If the original doesn't exist, search PATH as a fallback
if [ ! -x "$PIP" ]; then
    for path in $(echo "$PATH" | tr ':' '\n'); do
        candidate="$path/$SCRIPT_NAME"
        if [ -x "$candidate" ] && [ "$candidate" != "$0" ]; then
            PIP="$candidate"
            break
        fi
    done
fi
