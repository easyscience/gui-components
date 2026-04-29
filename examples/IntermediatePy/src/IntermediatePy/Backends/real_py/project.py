# SPDX-FileCopyrightText: 2024 EasyApp contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApp project <https://github.com/easyscience/EasyApp>

import time
from pathlib import Path
from PySide6.QtCore import QObject, Signal, Slot, Property

from EasyApplication.Logic.Logging import console
from .logic.helpers import IO
from .logic.helpers import DottyDict


_INFO = {
    'description': '',
    'location': str(Path.home()),
    'creationDate': ''
}

_EXAMPLES = [
    {
        'description': 'neutrons, powder, constant wavelength, HRPT@PSI',
        'name': 'La0.5Ba0.5CoO3 (HRPT)',
        'path': ':/Examples/La0.5Ba0.5CoO3_HRPT@PSI/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, HRPT@PSI',
        'name': 'La0.5Ba0.5CoO3-Raw (HRPT)',
        'path': ':/Examples/La0.5Ba0.5CoO3-Raw_HRPT@PSI/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, HRPT@PSI, 2 phases',
        'name': 'La0.5Ba0.5CoO3-Mult-Phases (HRPT)',
        'path': ':/Examples/La0.5Ba0.5CoO3-Mult-Phases_HRPT@PSI/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, D20@ILL',
        'name': 'Co2SiO4 (D20)',
        'path': ':/Examples/Co2SiO4_D20@ILL/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, G41@LLB',
        'name': 'Dy3Al5O12 (G41)',
        'path': ':/Examples/Dy3Al5O12_G41@LLB/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, D1A@ILL',
        'name': 'PbSO4 (D1A)',
        'path': ':/Examples/PbSO4_D1A@ILL/project.cif'
    },
    {
        'description': 'neutrons, powder, constant wavelength, 3T2@LLB',
        'name': 'LaMnO3 (3T2)',
        'path': ':/Examples/LaMnO3_3T2@LLB/project.cif'
    }
]


class Project(QObject):
    createdChanged = Signal()
    nameChanged = Signal()
    infoChanged = Signal()
    examplesChanged = Signal()

    def __init__(self):
        super().__init__()
        self._created = False
        self._name = ''
        self._info = _INFO
        self._examples = _EXAMPLES

    ##########################
    # GUI accessible variables
    ##########################

    # Properties

    @Property(bool, notify=createdChanged)
    def created(self):
        return self._created

    @created.setter
    def created(self, new_value):
        if self._created == new_value:
            return
        self._created = new_value
        self.createdChanged.emit()

    @Property(str, notify=nameChanged)
    def name(self):
        return self._name

    @name.setter
    def name(self, new_value):
        if self._name == new_value:
            return
        print(f" py: Changing project name from '{self.name}' to '{new_value}'")
        self._name = new_value
        self.nameChanged.emit()

    @Property('QVariant', notify=infoChanged)
    def info(self):
        return self._info

    @Property('QVariant', constant=True)
    def examples(self):
        return self._examples


    ##########################
    # GUI accessible functions
    ##########################

    @Slot()
    def create(self):
        print(f" py: Creating project '{self.name}'")
        self.info['creationDate'] = time.strftime("%d %b %Y %H:%M", time.localtime())
        self.infoChanged.emit()
        self.created = True

    @Slot()
    def save(self):
        print(f" py: Saving project '{self.name}'")

    @Slot(str, str)
    def editInfo(self, path, new_value):
        if DottyDict.get(self._info, path) == new_value:
            return
        print(f" py: Changing project info.{path} from '{DottyDict.get(self._info, path)}' to '{new_value}'")
        DottyDict.set(self._info, path, new_value)
        self.infoChanged.emit()
