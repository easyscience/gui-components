---
icon: material/cog-box
---

# :material-cog-box: Installation & Setup

**EasyApplication** is a cross-platform Python library compatible with
**Python 3.12** through **3.14**.

This section describes how to install EasyApplication using the
traditional method with **pip**. It is assumed that you are familiar
with Python package management and virtual environments.

### Environment Setup <small>optional</small> { #environment-setup data-toc-label="Environment Setup" }

We recommend using a **virtual environment** to isolate dependencies and
avoid conflicts with system-wide packages. If any issues arise, you can
simply delete and recreate the environment.

#### Creating and Activating a Virtual Environment:

<!-- prettier-ignore-start -->

- Create a new virtual environment:
  ```txt
  python3 -m venv venv
  ```
- Activate the environment:

    === ":material-apple: macOS"
        ```txt
        . venv/bin/activate
        ```
    === ":material-linux: Linux"
        ```txt
        . venv/bin/activate
        ```
    === ":fontawesome-brands-windows: Windows"
        ```txt
        . venv/Scripts/activate      # Windows with Unix-like shells
        .\venv\Scripts\activate.bat  # Windows with CMD
        .\venv\Scripts\activate.ps1  # Windows with PowerShell
        ```

- The terminal should now show `(venv)`, indicating that the virtual environment
  is active.

<!-- prettier-ignore-end -->

#### Deactivating and Removing the Virtual Environment:

<!-- prettier-ignore-start -->

- Exit the environment:
  ```txt
  deactivate
  ```
- If this environment is no longer needed, delete it:

    === ":material-apple: macOS"
        ```txt
        rm -rf venv
        ```
    === ":material-linux: Linux"
        ```txt
        rm -rf venv
        ```
    === ":fontawesome-brands-windows: Windows"
        ```txt
        rmdir /s /q venv
        ```

<!-- prettier-ignore-end -->

### Installing from PyPI { #from-pypi }

EasyApplication is available on **PyPI (Python Package Index)** and can
be installed using `pip`. To do so, use the following command:

```txt
pip install EasyApplication
```

To install a specific version of EasyApplication, e.g., 1.0.3:

```txt
pip install 'EasyApplication==1.0.3'
```

To upgrade to the latest version:

```txt
pip install --upgrade EasyApplication
```

To upgrade to the latest version and force reinstallation of all
dependencies (useful if files are corrupted):

```txt
pip install --upgrade --force-reinstall EasyApplication
```

To check the installed version:

```txt
pip show EasyApplication
```

### Installing from GitHub <small>alternative</small> { #from-github data-toc-label="Installing from GitHub" }

Installing unreleased versions is generally not recommended but may be
useful for testing.

To install EasyApplication from the `develop` branch of GitHub, for
example:

```txt
pip install git+https://github.com/easyscience/gui-components@develop
```

To include extra dependencies (e.g., dev):

```txt
pip install 'EasyApplication[dev] @ git+https://github.com/easyscience/gui-components@develop'
```
