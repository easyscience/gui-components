# SPDX-FileCopyrightText: 2026 EasyScience contributors <https://github.com/easyscience>
# SPDX-License-Identifier: BSD-3-Clause

import os
import pathlib
import re
import sys
import urllib.request

from EasyApp.Logic.Logging import console
from PySide6.QtCore import Property
from PySide6.QtCore import QObject
from PySide6.QtCore import QProcess
from PySide6.QtCore import Signal
from PySide6.QtCore import Slot
from PySide6.QtWidgets import QApplication


class Updater(QObject):
    # SIGNALS

    updateFound = Signal()
    updateNotFound = Signal()
    updateFailed = Signal()

    silentCheckChanged = Signal()
    errorMessageChanged = Signal()
    webVersionChanged = Signal()
    webDateChanged = Signal()
    releaseNotesChanged = Signal()

    # INIT

    def __init__(self, parent=None):
        super().__init__(parent)

        # private members
        self._silent_check = True
        self._error_message = ''
        self._web_version = ''
        self._web_date = ''
        self._release_notes = ''
        self._process = self._createUpdaterProcess()

        # connections
        self._process.started.connect(self._onStarted)
        self._process.finished.connect(self._onFinished)
        self._process.errorOccurred.connect(self._onErrorOccurred)

    # PUBLIC SLOTS

    @Slot()
    def checkUpdate(self):
        console.debug('Updater checkUpdate called')

        if self._process.state() == QProcess.Running:
            return

        self._process.setArguments(['--checkupdates', '--verbose'])
        self._process.start()

    @Slot()
    def installUpdate(self):
        """
        Start the external maintenance tool as detached process
        """
        console.debug('Updater installUpdate called')

        if self._process.state() == QProcess.Running:
            return

        program = os.path.join(self._process.workingDirectory(), self._process.program())
        arguments = ['--updater', '--verbose']

        updater_started = QProcess.startDetached(program, arguments)

        if updater_started:
            QApplication.quit()

    # PUBLIC PROPERTIES

    @Property(bool, notify=silentCheckChanged)
    def silentCheck(self):
        return self._silent_check

    @silentCheck.setter
    def silentCheck(self, silent_check: bool):
        if self._silent_check == silent_check:
            return

        self._silent_check = silent_check
        self.silentCheckChanged.emit()

    @Property(str, notify=errorMessageChanged)
    def errorMessage(self):
        return self._error_message

    @Property(str, notify=webVersionChanged)
    def webVersion(self):
        return self._web_version

    @Property(str, notify=webDateChanged)
    def webDate(self):
        return self._web_date

    @Property(str, notify=releaseNotesChanged)
    def releaseNotes(self):
        return self._release_notes

    # PRIVATE METHODS

    def _createUpdaterProcess(self):
        process = QProcess()
        process.setWorkingDirectory(QApplication.applicationDirPath())
        process.setProgram(Updater.exeRelativePath())
        return process

    def _onStarted(self):
        console.debug('Updater process started')
        self._web_version = ''
        self._web_date = ''
        self._error_message = ''
        self.webVersionChanged.emit()
        self.webDateChanged.emit()
        self.errorMessageChanged.emit()

    def _onFinished(self, exit_code: int, exit_status: QProcess.ExitStatus):
        console.debug(
            f'Updater process finished with exit code: '
            f"'{exit_code}' and exit status: '{exit_status}'"
        )

        # Get updater process output and error, if any
        std_out = self._process.readAllStandardOutput().data().decode('utf-8')
        std_err = self._process.readAllStandardError().data().decode('utf-8')

        # Debug printing
        if std_out:
            console.debug(f'Updater standard output:\n{std_out}')
        if std_err:
            console.debug(f'Updater standard error:\n{std_err}')

        # Something went wrong
        if exit_code != 0 or exit_status != QProcess.ExitStatus.NormalExit:
            console.debug('Updater process failed')
            self._error_message = (
                f'Updater process finished with\n* exit code: '
                f'{exit_code} \n* exit status: {exit_status}'
            )
            self.errorMessageChanged.emit()
            if not self.silentCheck:
                self.updateFailed.emit()
            return

        # Process finished succesfully
        console.debug('Updater process succeeded; checking for updates...')

        # Check if a new version of any of the app component is found
        pattern = r'<update.*version="([A-Za-z0-9.-]*)".*/>'
        matches = re.findall(pattern, std_out)

        # No new versions are found
        if not matches:
            console.debug('Updater did not find any updates')
            if not self.silentCheck:
                self.updateNotFound.emit()
            return

        # New version is found
        console.debug(f'Updater found component(s) with new version(s): {matches}')
        self._web_version = matches[0]  # TODO: Update this if multiple components are available
        self._web_date = self._getWebDate()
        self._release_notes = self._getReleaseNotes()
        self.webVersionChanged.emit()
        self.webDateChanged.emit()
        self.releaseNotesChanged.emit()

        # Trigger frontend dialog opening
        self.updateFound.emit()

    def _onErrorOccurred(self, error):
        console.debug(f"Updater process got error: '{error}'")
        self._error_message = error
        self.errorMessageChanged.emit()
        if not self.silentCheck:
            self.updateFailed.emit()

    def _getAppChangelog(self):
        path = Updater.appChangelogPath()
        try:
            return pathlib.Path(path).read_text()
        except Exception as exception:
            console.debug(f'Failed to read local file {path} with exception {exception}')
            return ''

    def _getWebChangelog(self):
        url = Updater.webChangelogUrl()
        try:
            with urllib.request.urlopen(url) as f:  # noqa
                return f.read().decode('utf-8')
        except Exception as exception:
            console.debug(f'Failed to read web file {url} with exception {exception}')
            return ''

    def _getReleaseNotes(self):
        app_changelog = self._getAppChangelog()
        web_changelog = self._getWebChangelog()
        # remove overlapping part
        release_notes = web_changelog.replace(app_changelog, '')
        # TODO: Temporary solution to change default headers size and
        #  empty lines (QML Text.MarkdownText)
        release_notes = re.sub(r'\n### ', '\n____\n#### ', release_notes)
        release_notes = re.sub(r'\n# ', '\n____\n____\n### ', release_notes)
        release_notes = re.sub(r'^# ', '### ', release_notes)
        return release_notes

    def _getWebDate(self):
        web_changelog = self._getWebChangelog()
        pattern = r'^# Version .*? \(([A-Za-z0-9\s]*)\)'
        matches = re.findall(pattern, web_changelog)
        web_date = matches[0]
        return web_date

    # STATIC METHODS

    @staticmethod
    def exeRelativePath():
        if sys.platform.startswith('win'):
            return '..\\MaintenanceTool.exe'
        elif sys.platform.startswith('darwin'):
            return '../../../MaintenanceTool.app/Contents/MacOS/MaintenanceTool'
        else:
            return '../MaintenanceTool'

    @staticmethod
    def appChangelogPath():
        if sys.platform.startswith('win'):
            relative_path = '..\\CHANGELOG.md'
        elif sys.platform.startswith('darwin'):
            relative_path = '../../../CHANGELOG.md'
        else:
            relative_path = '../CHANGELOG.md'
        path = os.path.join(QApplication.applicationDirPath(), relative_path)
        return path

    @staticmethod
    def webChangelogUrl():
        if sys.platform.startswith('win'):
            os_dir = 'Windows'
        elif sys.platform.startswith('darwin'):
            os_dir = 'macOS'
        else:
            os_dir = 'Linux'
        url = f'https://download.easydiffraction.org/onlineRepository/{os_dir}/CHANGELOG.md'
        return url
