# SPDX-FileCopyrightText: 2024 EasyApplication contributors
# SPDX-License-Identifier: BSD-3-Clause

from importlib.resources import files
from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType
from PySide6.QtCore import qInstallMessageHandler
from PySide6.QtGui import QIcon

from EasyApplication.Logic.Logging import console

from Backends.real_backend import Backend

# path to qml components of the current project
CURRENT_DIR = Path(__file__).parent

# path to the installed easyapplication module
EA_DIR = files("EasyApplication") / '..'


if __name__ == '__main__':
    qInstallMessageHandler(console.qmlMessageHandler)
    console.debug('Custom Qt message handler defined')

    # This singleton object will be accessible in QML as follows:
    # import Backends 1.0 as Backends OR import Backends as Backends
    # property var activeBackend: Backends.PyBackend
    qmlRegisterSingletonType(Backend, 'Backends', 1, 0, 'PyBackend')
    console.debug('Backend class is registered as a singleton type for QML')

    app = QGuiApplication(sys.argv)
    console.debug(f'Qt Application created {app}')
    app.setWindowIcon(QIcon(str(CURRENT_DIR / 'Gui' / 'Resources' / 'Logos' / 'App.svg')))

    engine = QQmlApplicationEngine()
    console.debug(f'QML application engine created {engine}')

    engine.addImportPath(CURRENT_DIR)
    engine.addImportPath(EA_DIR)
    console.debug('Paths added where QML searches for components')

    engine.load(CURRENT_DIR / 'main.qml')
    console.debug('Main QML component loaded')

    console.debug('Application event loop is about to start')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
