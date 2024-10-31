# areq

`areq` is a command-line tool that keeps your `requirements.txt` file up to date. It wraps around `pip` and automatically adds or removes packages when you install or uninstall them.

## Features

- Updates `requirements.txt` when you install/uninstall packages.
- Handles system Python restrictions (e.g., on Linux) with `--break-system-packages`.
- Keeps `requirements.txt` sorted with a timestamp.

## Installation

You need Python 3.6+ and `pip`. Run this to install:

```bash
curl -sSL https://raw.githubusercontent.com/yourusername/areq/main/install.sh | bash
