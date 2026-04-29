# SPDX-FileCopyrightText: 2024 EasyApplication contributors
# SPDX-License-Identifier: BSD-3-Clause

from importlib.resources import files
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType

from Backends.real_backend import Backend

# path to qml components of the current project
CURRENT_DIR = Path(__file__).parent

# path to the installed easyapplication module
EA_DIR = files("EasyApplication") / '..'


if __name__ == '__main__':
    # Register the Backend class as a singleton type for QML
    # This singleton object will be accessible in QML as follows:
    # import Backends 1.0 as Backends OR import Backends as Backends
    # property var activeBackend: Backends.PyBackend
    qmlRegisterSingletonType(Backend, 'Backends', 1, 0, 'PyBackend')

    # Create Qt application
    app = QGuiApplication(sys.argv)

    # Create the QML application engine
    engine = QQmlApplicationEngine()

    # Add the paths where QML searches for components
    engine.addImportPath(CURRENT_DIR)
    engine.addImportPath(EA_DIR)

    # Load the main QML component
    engine.load(CURRENT_DIR / 'main.qml')

    # Start the application event loop
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
