# SPDX-FileCopyrightText: 2024 EasyApplication contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

from PySide6.QtCore import QObject, Signal, Property


_HTML = """<!DOCTYPE html>
<html>
<style>
    th, td { padding-right: 18px; }
    th { text-align: left; }
</style>
<body>
    <table>
    <tr></tr>
    <tr>
        <td><h1>Summary</h1></td>
    </tr>
    <tr></tr>
    <tr>
        <td><h3>Project information</h3></td>
    </tr>
    <tr></tr>
    <tr>
        <th>Name</th>
        <th>La0.5Ba0.5CoO3</th>
    </tr>
    <tr>
        <td>Description</td>
        <td>neutrons, powder, constant wavelength</td>
    </tr>
    <tr>
        <td>No. of phases</td>
        <td>1</td>
    </tr>
    <tr>
        <td>No. of experiments</td>
        <td>1</td>
    </tr>
    <tr></tr>
        <tr>
            <td><h3>Crystal data</h3></td>
        </tr>
        <tr></tr>
    <tr>
        <th>Phase datablock</th>
        <th>lbco</th>
    </tr>
    <tr>
        <td>Crystal system, space group</td>
        <td>cubic,&nbsp;&nbsp;<i>P m -3 m</i></td>
    </tr>
    <tr></tr>
        <tr>
            <td><h3>Data collection</h3></td>
        </tr>
        <tr></tr>
    <tr>
        <th>Experiment datablock</th>
        <th>hrpt</th>
    </tr>
    <tr>
        <td>Radiation probe</td>
        <td>neutron</td>
    </tr>
    <tr>
        <td>Measured range: min, max, inc (&deg;)</td>
        <td>10.0,&nbsp;&nbsp;164.85,&nbsp;&nbsp;0.05</td>
    </tr>
    <tr></tr>
    </table>
</body>
</html>
"""


class Report(QObject):
    createdChanged = Signal()
    asHtmlChanged = Signal()

    def __init__(self):
        super().__init__()
        self._created = False
        self._asHtml = _HTML

    ##########################
    # GUI accessible variables
    ##########################

    @Property(bool, notify=createdChanged)
    def created(self):
        return self._created

    @created.setter
    def created(self, new_value):
        if self._created == new_value:
            return
        self._created = new_value
        self.createdChanged.emit()

    @Property(str, notify=asHtmlChanged)
    def asHtml(self):
        return self._asHtml

    @asHtml.setter
    def asHtml(self, new_value):
        if self._asHtml == new_value:
            return
        self._asHtml = new_value
        self.asHtmlChanged.emit()
