# Auto-Req (areq)
## Overview
`areq` is a simple command-line tool that keeps your `requirements.txt` file up to date. It wraps around `pip` and automatically adds or removes packages when you install or uninstall them.
As someone who enjoys the simplicity of pip for managing my environments and not having to stress about the state of my `requirements.txt` file, I created `areq` to automate this process. It's a small tool that makes a big difference in my workflow, and I hope it does the same for you.

## Features
- Updates `requirements.txt` when you install/uninstall packages **automatically**.
- Keeps `requirements.txt` sorted.

## Installation

You need Python 3.6+ and `pip`. Run this to install:

```bash
# unix shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/0xdvc/auto-req/main/install.sh)"
```
