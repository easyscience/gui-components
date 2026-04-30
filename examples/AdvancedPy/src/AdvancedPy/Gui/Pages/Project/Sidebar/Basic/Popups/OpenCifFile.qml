// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Components as EaComponents

import Gui.Globals as Globals


FileDialog{

    id: openCifFileDialog

    fileMode: FileDialog.OpenFile
    nameFilters: [ 'CIF files (*.cif)']

    onAccepted: {
        Globals.References.applicationWindow.appBarCentralTabs.summaryButton.enabled = true
    }

    Component.onCompleted: {
        Globals.References.pages.project.sidebar.basic.popups.openCifFile = openCifFileDialog
    }

}
