# SPDX-FileCopyrightText: 2026 EasyScience contributors <https://github.com/easyscience>
# SPDX-License-Identifier: BSD-3-Clause

import inspect
import logging
import os
import pathlib
import sys
import time

from PySide6.QtCore import Property
from PySide6.QtCore import QObject
from PySide6.QtCore import QSettings
from PySide6.QtCore import QtMsgType
from PySide6.QtCore import QUrl
from PySide6.QtCore import Signal

LOGGER_LEVELS = {
    'disabled': 40,
    # logging.CRITICAL, logging.ERROR, QtMsgType.QtSystemMsg,
    # QtMsgType.QtCriticalMsg, QtMsgType.QtFatalMsg
    'error': 30,
    # logging.INFO, logging.WARNING, QtMsgType.QtInfoMsg,
    # QtMsgType.QtWarningMsg
    'info': 20,
    # logging.NOTSET, logging.DEBUG, QtMsgType.QtDebugMsg
    'debug': 10,
}

COUNT_WIDTH = 5
CATEGORY_WIDTH = 4
LEVEL_WIDTH = 7
FUNC_NAME_WIDTH = 34
MAIN_MSG_WIDTH = 150


class Logger:
    def __init__(self):
        self._count = 0
        self._level = self._getLevelFromSettings()
        self._getLevelFromSettings()
        self._startTime = time.time()

        self._consoleFormat = logging.Formatter('{message}', datefmt='%H:%M:%S', style='{')
        self._consoleHandler = logging.StreamHandler()
        self._consoleHandler.setFormatter(self._consoleFormat)

        self._logger = logging.getLogger()
        self._logger.setLevel(logging.NOTSET)
        self._logger.addHandler(self._consoleHandler)

    def debug(self, msg):
        level = 'debug'
        self._pyMessageHandler(level, msg)

    def info(self, msg):
        level = 'info'
        self._pyMessageHandler(level, msg)

    def error(self, msg):
        level = 'error'
        self._pyMessageHandler(level, msg)

    def qmlMessageHandler(self, msgType, context, msg):
        level = Logger.qtMsgTypeToCustomLevel(msgType)
        if LOGGER_LEVELS[level] < LOGGER_LEVELS[self._level]:
            return
        category = 'qml'
        funcName = context.function
        filePath = QUrl(context.file).toLocalFile()
        if filePath == '':
            filePath = None
        lineNo = context.line
        self._print(msg, level, category, funcName, filePath, lineNo)

    def _pyMessageHandler(self, level, msg):
        if LOGGER_LEVELS[level] < LOGGER_LEVELS[self._level]:
            return
        category = 'py'
        caller = inspect.getframeinfo(sys._getframe(2))
        funcName = caller.function
        filePath = os.path.relpath(caller.filename)
        lineNo = caller.lineno
        self._print(msg, level, category, funcName, filePath, lineNo)

    def _print(self, msg, level, category, funcName, filePath, lineNo):
        msg = msg.replace('file://', '')
        rest = Logger.rest(msg, MAIN_MSG_WIDTH)
        msg = self._formattedConsoleMsg(msg, level, category, funcName, filePath, lineNo)
        self._logger.debug(msg)
        if rest:
            self._logger.debug(rest)

    def _getLevelFromSettings(self):
        # NEED FIX: Duplication from main.py
        appName = 'EasyDiffraction'  # NEED FIX
        homeDirPath = pathlib.Path.home()
        settingsIniFileName = 'settings.ini'
        settingsIniFilePath = str(homeDirPath.joinpath(f'.{appName}', settingsIniFileName))
        settings = QSettings(settingsIniFilePath, QSettings.IniFormat)
        level = settings.value('Preferences.Develop/loggingLevel', 'debug')
        level = level.lower()
        return level

    def _timing(self):
        endTime = time.time()
        timing = endTime - self._startTime
        self._startTime = endTime
        if timing < 0.001:
            return ' ' * 8
        elif timing < 60:
            return f'{timing:7.3f}s'
        elif timing < 3600:
            timing /= 60
            return f'{timing:7.3f}m'
        else:
            timing /= 3600
            return f'{timing:7.3f}h'

    def _colorize(self, txt, level, category):
        # https://www.unixtutorial.org/how-to-show-colour-numbers-in-unix-terminal/
        grey = '\x1b[38;5;252m'
        green = '\x1b[38;5;149m'
        blue = '\x1b[38;5;81m'
        yellow = '\x1b[38;5;222m'
        red = '\x1b[38;5;204m'
        reset = '\x1b[0m'
        if level == 'error':
            return f'{red}{txt}{reset}'
        elif level == 'info':
            return f'{blue}{txt}{reset}'
        elif level == 'debug':
            if category == 'py':
                return f'{yellow}{txt}{reset}'
            elif category == 'qml':
                return f'{green}{txt}{reset}'
            else:
                return f'{grey}{txt}{reset}'
        return txt

    def _formattedConsoleMsg(self, msg, level, category, funcName, filePath, lineNo):
        self._count += 1
        if funcName is None:
            funcName = ''
        sourceUrl = ''
        try:
            cwd = os.getcwd()
            parent = os.path.join(cwd, '..')
            start = os.path.abspath(parent)
            relativePath = os.path.relpath(filePath, start)
            fileUrl = f'file:///{relativePath}'
            sourceUrl = f'{fileUrl}:{lineNo}'
        except:  # noqa
            pass
        txt = (
            f'{self._count:>{COUNT_WIDTH}d} {self._timing()} {category:>{CATEGORY_WIDTH}} '
            f'{level:<{LEVEL_WIDTH}} {msg:<{MAIN_MSG_WIDTH}.{MAIN_MSG_WIDTH}} '
            f'{funcName:<{FUNC_NAME_WIDTH}.{FUNC_NAME_WIDTH}} {sourceUrl}'
        )
        txt = self._colorize(txt, level, category)
        return txt

    @staticmethod
    def qtMsgTypeToCustomLevel(msgType):
        return {
            QtMsgType.QtDebugMsg: 'debug',
            QtMsgType.QtInfoMsg: 'info',
            QtMsgType.QtWarningMsg: 'info',
            QtMsgType.QtCriticalMsg: 'error',
            QtMsgType.QtSystemMsg: 'error',
            QtMsgType.QtFatalMsg: 'error',
        }[msgType]

    @staticmethod
    def rest(s, n):
        splitted = [' ' * 28 * bool(i) + s[i : i + n] for i in range(0, len(s), n)]
        joined = '\n'.join(splitted[1:])
        return joined


console = Logger()


class LoggerLevelHandler(QObject):
    levelChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._level = 'debug'

    # QML accessible properties

    @Property(str, notify=levelChanged)
    def level(self):
        return self._level

    @level.setter
    def level(self, newValue):
        newValue = newValue.lower()
        if self._level == newValue:
            return
        self._level = newValue
        self.levelChanged.emit()
        console._level = self._level
