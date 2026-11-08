import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Elements as EaElements

// The custom Button, which owns the tooltip; a bare `Button` here would resolve to the Qt Controls one.
EaElements.Button {
    id: control

    implicitWidth: (parent.width - parent.spacing) * 0.5 - 1

    topInset: 0
    bottomInset: 0
    padding: 0

    icon.height: 18
    icon.width: 18

    font.capitalization: Font.MixedCase

    flat: true
    Material.elevation: 0
    Material.background: EaStyle.Colors.statusBarBackground

    // Background for disabled buttons
    Rectangle {
        anchors.fill: parent
        color: enabled ? "transparent" : Material.background
    }
}
