# Auto-Req (areq)
## Overview
Ever had to push code and only realize after pushing that you forgot to add a package to your `requirements.txt` file? And, no one wants to change the package manager from `pip` to another tool like `conda`, `poetry`, or even `pipenv`. Or you just don't want to deal with the hassle of managing multiple package managers. Well, that was the frustration that led me to this idea of a tool.

`areq` is a simple python library that keeps your `requirements.txt` file up to date. It wraps around `pip` and automatically adds or removes packages when you install or uninstall them.
As someone who enjoys the simplicity of `pip` for managing my environments and not having to stress about the state of my `requirements.txt` file, I created `areq` to automate this process. It's a small tool that makes a big difference in my workflow, and I hope it does the same for you.

## Features
- Updates `requirements.txt` when you install/uninstall packages **automatically**.
- Keeps `requirements.txt` sorted.

## Installation
You need Python 3.6+ and `pip`. Run this to install:

```bash
# unix shell
bash <(curl -sL https://raw.githubusercontent.com/0xdvc/auto-req/main/scripts/install.sh)
```

## Uninstallation
```bash
# unix shell
pip uninstall areq # that simple :)
```

## Things to note before using `areq`
- After installation, it should generate a requirements.txt file if it doesn't exist and track all packages you install via `pip`.
- All previous installations are tracked on installation and further installations and uninstallations are tracked.
- Uninstalling a package will remove it from the requirements.txt file.

## Limitations
- `areq` only tracks packages installed via `pip`. If you install packages via other means, you will have to manually update the requirements.txt file.
- `areq` does not track the package's extras. It only tracks the package name. (I do think it's great though for now, I can't tell for now what other packages rely on those extras. you could have co-dependencies on those extras)


## Future work
- allow support for updates by some config
- write a batch script for windows users
- add support for tracking extras (if possible) _#issue might be with identifying other libraries that actually depend the said extras_
- publish to PyPi

## Resources
- Introduction to Bash scripting - [By Bobby Iliev](https://ebook.bobby.sh/#download)
- Packaging python projects - [Python Packaging Authority](https://packaging.python.org/tutorials/packaging-projects/)
- How to create a setup file for your project - [Python for the lab](https://pythonforthelab.com/blog/how-create-setup-file-your-project)

## LICENSE
MIT License

Copyright (c) 2024 Neil Ohene

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
