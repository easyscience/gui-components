// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick
import QtQuick.Controls
//import QtQuick.Dialogs

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements
import EasyApplication.Gui.Components as EaComponents
import EasyApplication.Gui.Logic as EaLogic

import Gui.Globals as Globals


Grid {

    columns: 2
    spacing: EaStyle.Sizes.fontPixelSize

    // button 1
    EaElements.SideBarButton {
        fontIcon: 'plus-circle'
        text: qsTr('Create a new project')

        onClicked: {
            console.debug(`Clicking '${text}' button ::: ${this}`)
            EaGlobals.Vars.showProjectDescriptionDialog = true
        }

        Loader {
            source: '../Popups/ProjectDescription.qml'
        }
    }
    // button 1

    // button 2
    EaElements.SideBarButton {
        fontIcon: 'upload'
        text: qsTr('Open an existing project')

        onClicked: {
            console.debug(`Clicking '${text}' button ::: ${this}`)
            Globals.References.pages.project.sidebar.basic.popups.openCifFile.open()
        }

        Loader {
            source: '../Popups/OpenCifFile.qml'
        }
    }
    // button 2

}
