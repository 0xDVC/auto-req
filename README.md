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


## Usage
- After installation, it should generate a requirements.txt file if it doesn't exist and track all packages you install via `pip`.
- All previous installations are tracked on installation and further installations and uninstallations are tracked.
- Uninstalling a package will remove it from the requirements.txt file.



## Resources
- Introduction to Bash scripting - [By Bobby Iliev](https://ebook.bobby.sh/#download)
- Packaging python projects - [Python Packaging Authority](https://packaging.python.org/tutorials/packaging-projects/)
- How to create a setup file for your project - [Python for the lab](https://pythonforthelab.com/blog/how-create-setup-file-your-project)
