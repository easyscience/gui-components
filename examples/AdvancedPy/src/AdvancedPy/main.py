# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from pathlib import Path
import sys

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterSingletonType
from PySide6.QtCore import qInstallMessageHandler
from PySide6.QtGui import QIcon

# It is usually assumed that the EasyApp package is already installed in the desired python environment.
# If this is not the case, and if the example is run from the EasyApp repository, one need to add the path to the
# EasyApp source code.
CURRENT_DIR = Path(__file__).parent  # path to qml components of the current project
EASYAPP_DIR = CURRENT_DIR / '..' / '..' / '..' / '..' / 'src'  # path to qml components of the easyapp module
sys.path.append(str(EASYAPP_DIR))

from EasyApp.Logic.Logging import console

from Backends.real_backend import Backend


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
    engine.addImportPath(EASYAPP_DIR)
    console.debug('Paths added where QML searches for components')

    engine.load(CURRENT_DIR / 'main.qml')
    console.debug('Main QML component loaded')

    console.debug('Application event loop is about to start')
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
