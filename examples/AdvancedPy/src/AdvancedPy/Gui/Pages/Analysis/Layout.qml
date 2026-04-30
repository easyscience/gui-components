// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick
import QtQuick.Controls

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Elements as EaElements
import EasyApplication.Gui.Components as EaComponents

import Gui.Globals as Globals


EaComponents.ContentPage {

    mainView: EaComponents.MainContent {
        tabs: [
            EaElements.TabButton { text: qsTr('Chart') }
        ]

        items: [
            Loader { source: 'MainArea/Chart.qml' }
        ]
    }

    sideBar: EaComponents.SideBar {
        tabs: [
            EaElements.TabButton { text: qsTr('Basic controls') }
        ]

        items: [
            Loader { source: 'Sidebar/Basic/Layout.qml' }
        ]

        continueButton.text: qsTr('Continue')

        continueButton.onClicked: {            
            console.debug(`Clicking '${continueButton.text}' button ::: ${this}`)
            Globals.References.applicationWindow.appBarCentralTabs.summaryButton.enabled = true
            Globals.References.applicationWindow.appBarCentralTabs.summaryButton.toggle()
        }
    }

    Component.onCompleted: console.debug(`Analysis page loaded ::: ${this}`)
    Component.onDestruction: console.debug(`Analysis page destroyed ::: ${this}`)

}
