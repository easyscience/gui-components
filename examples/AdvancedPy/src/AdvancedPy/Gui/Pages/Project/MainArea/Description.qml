// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements

import Gui.Globals as Globals


Rectangle {

    readonly property int commonSpacing: EaStyle.Sizes.fontPixelSize * 1.5

    color: EaStyle.Colors.mainContentBackground

    Column {
        id: container

        anchors.top: parent.top
        anchors.left: parent.left

        anchors.topMargin: commonSpacing
        anchors.leftMargin: commonSpacing * 1.5

        spacing: commonSpacing

        // Project title
        EaElements.TextInput {
            width: Math.max(implicitWidth, 1)
            font.family: EaStyle.Fonts.secondFontFamily
            font.pixelSize: EaStyle.Sizes.fontPixelSize * 3
            font.weight: Font.ExtraLight
            validator: RegularExpressionValidator { regularExpression: /^[a-zA-Z][a-zA-Z0-9_\-\.]{1,30}$/ }
            placeholderText: qsTr("Enter project name here")
            text: Globals.BackendWrapper.projectName
            onEditingFinished: Globals.BackendWrapper.projectName = text
        }
        // Project title

        // Project info
        Grid {
            columns: 2
            rowSpacing: 0
            columnSpacing: commonSpacing

            EaElements.Label {
                font.bold: true
                text: qsTr('Description:')
            }
            EaElements.TextInput {
                width: Math.max(implicitWidth, 1)
                placeholderText: qsTr("Enter project description here")
                text: Globals.BackendWrapper.projectInfo.description
                onEditingFinished: Globals.BackendWrapper.projectEditInfo('description', text)
            }

            EaElements.Label {
                font.bold: true
                text: qsTr('Location:')
            }
            EaElements.Label {
                width: Math.max(implicitWidth, 1)
                text: Globals.BackendWrapper.projectInfo.location
            }

            EaElements.Label {
                font.bold: true
                text: qsTr('Created:')
            }
            EaElements.Label {
                width: Math.max(implicitWidth, 1)
                text: Globals.BackendWrapper.projectInfo.creationDate
            }
        }
        // Project info

        // Project image
        Image {
            width: EaStyle.Sizes.fontPixelSize * 25
            fillMode: Image.PreserveAspectFit
        }
        // Project image

    }

}
