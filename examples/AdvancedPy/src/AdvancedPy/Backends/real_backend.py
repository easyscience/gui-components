# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

from PySide6.QtCore import QObject, Property

from EasyApp.Logic.Logging import LoggerLevelHandler

from .real_py.project import Project
from .real_py.analysis import Analysis
from .real_py.status import Status
from .real_py.report import Report


class Backend(QObject):
    def __init__(self):
        super().__init__()

        ####################
        # Private attributes
        ####################

        # Individual Backend objects
        self._project = Project()
        self._analysis = Analysis()
        self._status = Status()
        self._report = Report()

        # Logger
        self._logger = LoggerLevelHandler(self)

        #############
        # Connections
        #############

        # Connect the signals of various Backend objects to the methods of this class defined below.
        # This allows, through the methods of this class, to update dependent objects, but keep them
        # unaware of each other.

        # Project
        self._project.nameChanged.connect(self.onProjectNameChanged)
        self._project.createdChanged.connect(self.onProjectCreatedChanged)

    ##########################
    # GUI accessible variables
    ##########################

    @Property('QVariant', constant=True)
    def project(self):
        return self._project

    @Property('QVariant', constant=True)
    def analysis(self):
        return self._analysis

    @Property('QVariant', constant=True)
    def status(self):
        return self._status

    @Property('QVariant', constant=True)
    def report(self):
        return self._report

    ##################################
    # Functions related to connections
    ##################################

    # Project

    def onProjectNameChanged(self):
        self._status.project = self._project.name
        self._report._asHtml = self._project.name

    def onProjectCreatedChanged(self):
        self._report.created = self._project.created
