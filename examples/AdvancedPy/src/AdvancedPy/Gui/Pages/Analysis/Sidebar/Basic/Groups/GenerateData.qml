// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick
import QtQuick.Controls

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements
import EasyApplication.Gui.Components as EaComponents
import EasyApplication.Gui.Logic as EaLogic

import Gui.Globals as Globals

EaElements.GroupColumn {

    // 1st row
    EaElements.GroupRow {
        spacing: EaStyle.Sizes.fontPixelSize

        // button
        EaElements.SideBarButton {
            id: generateDataButton

            fontIcon: 'plus-circle'
            text: qsTr('Generate new data')

            onClicked: {
                console.debug(`Clicking '${text}' button ::: ${this}`)
                Globals.BackendWrapper.activeBackend.analysis.generateData()
            }
        }
        // button

        // text input
        EaElements.ParamTextField {
            height: generateDataButton.height

            inputMethodHints: Qt.ImhDigitsOnly
            validator: IntValidator {
                bottom: 2
                top: 100000
            }

            value: Globals.BackendWrapper.activeBackend.analysis.dataSize
            units: 'points'

            onTextChanged: {
                if (acceptableInput) {
                    Globals.BackendWrapper.activeBackend.analysis.dataSize = text
                } else {
                    console.warn("Input value must belong to [2, 100'000]")
                }
            }
        }
        // text input
    }
    // 1st row
}
