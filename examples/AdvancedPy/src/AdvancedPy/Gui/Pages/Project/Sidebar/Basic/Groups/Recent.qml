// SPDX-FileCopyrightText: 2024 EasyApplication contributors
// SPDX-License-Identifier: BSD-3-Clause
// © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

import QtQuick
import QtQuick.Controls
import QtCore

import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements
import EasyApplication.Gui.Components as EaComponents
import EasyApplication.Gui.Logic as EaLogic

import Gui.Globals as Globals


EaComponents.TableView {

    id: tableView

    showHeader: false
    tallRows: true
    maxRowCountShow: 6

    defaultInfoText: qsTr('No recent projects found')

    // Header row
    header: EaComponents.TableViewHeader {

        EaComponents.TableViewLabel {
            enabled: false
            width: EaStyle.Sizes.fontPixelSize * 2.5
        }

    }
    // Header row

}
