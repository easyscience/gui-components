// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements


Column {

    property int labelsCount: 50

    spacing: EaStyle.Sizes.fontPixelSize

    Repeater {
        model: labelsCount
        EaElements.Label {
            text: `Label ${index+1} of ${labelsCount}`
        }
    }

}

