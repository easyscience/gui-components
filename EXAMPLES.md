## Types of examples

Different types of examples are given here. All examples have a graphical frontend implemented in QML, but differ in the way the backend logic is implemented and the runtime used to run them. These examples can be categorised as shown in the following table:

| Example        | Type | Frontend | Backend  | Runtime              |
| -------------- | ---- | -------- | -------- | -------------------- |
| BasicQml       | I    | QML      | Mock QML | `qml` tool           |
| BasicPy        | II   | QML      | Mock QML | `python` interpreter |
| IntermediatePy | III  | QML      | Python   | `python` interpreter |
| AdvancedPy     | III  | QML      | Python   | `python` interpreter |
| BasicC++       | IV   | QML      | Mock QML | need to be compiled  |

## Setting up Python and IDE 

### Python environment

* Create and activate a python environment (_optional_)

  ***macOS and Linux***

  ```
  python3 -m venv .venv
  source .venv/bin/activate
  ```

  ***Windows***

  ```
  python3 -m venv .venv
  .venv\Scripts\activate
  ```

* Upgrade PIP, the package installer for Python (_optional_)

  ```
  pip install --upgrade pip
  ```
  
* Install the Qt for Python `PySide6` package using PIP

  ```
  pip install PySide6 
  ```

### Integrated development environment (IDE)

#### Qt Creator

Qt Creator is a prefered IDE for developing the GUI in QML. It allows to run QML code in debug mode with breakpoints, preview changes to QML code in live mode, has build in documentation for QML modules, has QML code auto-completion, and more unique feature related to the QML code.

* Download Qt Online Installer from [qt.io](https://www.qt.io/download-qt-installer-oss). More info at [doc.qt.io](https://doc.qt.io/qt-6/qt-online-installation.html).
* Install Qt for desktop development using a custom installation that includes the following components:
    * Qt
	   * [ ] Qt 6.9.z
	       * [x] Desktop (***macOS***) or MSVC 2019 64-bit (***Windows***)
   	       * [ ] Additional Libraries
   	           * [x] Qt Charts  
   	           * [x] Qt Shader Tools
	   * [ ] Developer and Designer Tools
	       * [x] Qt Creator x.y.z

#### VS Code (_alternative to Qt Creator_)

VS Code is an alternative IDE to Qt Creator. It has a syntax highlighting plugin for QML code, but lacks some of the unique features of Qt Creator mentioned above to make QML development easier.

* Download an install VS Code
* Add the python extension
* The initial launch configuration is in the `.vscode/launch.json` file, which should be automatically read by VS Code
* Select any python file in the repo and choose the desired python environment

## How to run

### Type I Examples: BasicQml (QML runtime with QML backend)

This example is located in `examples/BasicQml` and the source code is in the subfolder `src/BasicQml`. The example consists of a graphical QML frontend (`Gui/Application.qml`) and a QML backend (`Logic/Mock/BackendProxy.qml`). It is considered a mock backend as it only returns hardcoded values rather than providing the required functionality. The entry point for Qt is `main.qml`, which can be displayed using Qt `qml` viewer.

#### Run using the QML Runtime

##### Run via the Qt Creator IDE

* Run Qt Creator
* Open the qml project file from the example folder `examples/BasicQml/src/BasicQml.qmlproject`
* Click Run (Green play button)

#### How to edit GUI elements in live mode

* In Qt Creator, select the `*.qml` file to be edited in live mode
* Click the `Design` button at the top of the left sidebar of `Qt Creator`
    * _Note: If this button is disabled, find and click `About plugins...` in the `Qt Creator` menu, scroll down to the `Qt Quick` section and enable `QmlDesigner`._
* In the `Design` window, click the `Show Live Preview` button in the top panel of the application (small play button in a circle).
    * _Note: Showing the entire `main.qml` application window in live mode works best when the open `main.qml` is moved to another monitor and does not overlap with the `Qt Creator` window_.
* When the desired GUI component appears, you can click the `Edit` button at the top of the left sidebar of `Qt Creator` to return to the source code of that qml component and still see it live in a separate window.

### Type II Examples: BasicPy (Python runtime with QML backend)

This example is in the `examples/BasicPy` folder, and the source code is in the `examples/BasicPy/src/BasicPy` folder. This example serves to demonstrate how an application with a QML frontend and QML backend (similar to the Type I example) can be run from Python. The entry point for the Python application is the `main.py` file. To run it, follow the steps below:

#### Run using the Python interpreter

##### Run from the terminal

* Go to the example folder, e.g.,

  ```sh
  $ cd examples/BasicPy/src/BasicPy
  ```
* Run using Python (provided that the required python environment is activated as explained above)

  ```sh
  $ python main.py
  ```

##### Run via the Qt Creator IDE (_alternative to run from the terminal_)

* Run Qt Creator
* Open the python project file from the example folder `examples/BasicPy/src/BasicPy.pyproject`
* Select the desired python environment with the Qt `PySide6` module installed
* Click Run (Green play button)

##### Run via the VS Code IDE (_alternative to run from the terminal or via the Qt Creator IDE_)

* Open the repo in VS Code
* Click on the debug extension and select which example to execute
![Debug dropdown window](resources/images/vscode_debug.jpg)

### Type III Examples: IntermediatePy and AdvancedPy (Python runtime with Python backend)

These examples demonstrate how to use the Python runtime to run the QML GUI binded with the Python backend located in `Backends/real_backend.py`. These examples can be run through Python in the same way as Type II described above. In these examples, the Python-based backend is registered in `main.py` and then imported into QML. The Qt QML GUI then accesses the backend by calling the properties and methods of the classes defined in the `Backends/real_py` folder.

#### Possible Issues

* If in Qt Creator some components are highlighted and marked as "Unknown component. (M300)", try resetting via "Tools > QML/JS > Reset Code Model".

### Type IV Examples: BasicC++ (QML backend)

This example can be run after compilation into an executable program. It only has a mock backend in QML (the C++ backend is not implemented). The minimum configuration requires a base `main.cpp` file and, if Qt Creator is used as the IDE, a `*.pro` file.

This example is currently used to create a WebAssembly application that can be run inside a web browser.
