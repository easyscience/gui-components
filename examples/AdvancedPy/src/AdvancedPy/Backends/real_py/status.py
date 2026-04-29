# SPDX-FileCopyrightText: 2024 EasyApplication contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

from PySide6.QtCore import QObject, Signal, Property


class Status(QObject):
    projectChanged = Signal()
    phasesCountChanged = Signal()
    experimentsCountChanged = Signal()
    calculatorChanged = Signal()
    minimizerChanged = Signal()
    variablesChanged = Signal()

    def __init__(self):
        super().__init__()
        self._project = 'Undefined'
        self._phasesCount = '1'
        self._experimentsCount = '1'
        self._calculator = 'CrysPy'
        self._minimizer = 'Lmfit (leastsq)'
        self._variables = '31 (3 free, 28 fixed)'

    ##########################
    # GUI accessible variables
    ##########################

    @Property(str, notify=projectChanged)
    def project(self):
        return self._project

    @project.setter
    def project(self, new_value):
        if self._project == new_value:
            return
        self._project = new_value
        self.projectChanged.emit()

    @Property(str, notify=phasesCountChanged)
    def phasesCount(self):
        return self._phasesCount

    @phasesCount.setter
    def phasesCount(self, new_value):
        if self._phasesCount == new_value:
            return
        self._phasesCount = new_value
        self.phasesCountChanged.emit()

    @Property(str, notify=experimentsCountChanged)
    def experimentsCount(self):
        return self._experimentsCount

    @experimentsCount.setter
    def experimentsCount(self, new_value):
        if self._experimentsCount == new_value:
            return
        self._experimentsCount = new_value
        self.experimentsCountChanged.emit()

    @Property(str, notify=calculatorChanged)
    def calculator(self):
        return self._calculator

    @calculator.setter
    def calculator(self, new_value):
        if self._calculator == new_value:
            return
        self._calculator = new_value
        self.calculatorChanged.emit()

    @Property(str, notify=minimizerChanged)
    def minimizer(self):
        return self._minimizer

    @minimizer.setter
    def minimizer(self, new_value):
        if self._minimizer == new_value:
            return
        self._minimizer = new_value
        self.minimizerChanged.emit()

    @Property(str, notify=variablesChanged)
    def variables(self):
        return self._variables

    @variables.setter
    def variables(self, new_value):
        if self._variables == new_value:
            return
        self._variables = new_value
        self.variablesChanged.emit()
