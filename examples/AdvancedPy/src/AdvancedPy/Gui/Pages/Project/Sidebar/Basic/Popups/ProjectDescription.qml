// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick
import QtQuick.Controls

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Components as EaComponents

import Gui.Globals as Globals


EaComponents.ProjectDescriptionDialog {

    visible: EaGlobals.Vars.showProjectDescriptionDialog
    onClosed: EaGlobals.Vars.showProjectDescriptionDialog = false

    projectName: Globals.BackendWrapper.projectName
    projectDescription: Globals.BackendWrapper.projectInfo.description

    onAccepted: {
        Globals.BackendWrapper.projectName = projectName
        Globals.BackendWrapper.projectEditInfo('description', projectDescription)
        Globals.BackendWrapper.projectCreate()
        Globals.References.applicationWindow.appBarCentralTabs.summaryButton.enabled = true
    }

    Component.onCompleted: {
        projectLocation = Globals.BackendWrapper.projectInfo.location
    }

}
