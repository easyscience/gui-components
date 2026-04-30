// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick

import EasyApplication.Gui.Elements as EaElements
import EasyApplication.Gui.Components as EaComponents

import Gui.Globals as Globals


EaComponents.SideBarColumn {

    EaElements.GroupBox {
        enabled: false
        title: qsTr('Export summary')
        icon: 'download'
        collapsed: false

        Loader { source: 'Groups/Export.qml' }
    }

}
