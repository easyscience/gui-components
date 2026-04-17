import QtQuick

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements

EaElements.TextInput {
    id: control

    property string headerText: ""

    height: parent.height
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    hoverEnabled: true

    // ListView has its own row selection, so we don't need the TableView-style
    // "highlight the last-edited cell" behaviour — hence this separate component
    // with a color override. Track activeFocus (real keyboard focus) rather than
    // the per-FocusScope `focus` flag used in TextInput.qml, so sibling
    // ListViewDelegates don't stay blue after editing ends.
    color: warned ?
               EaStyle.Colors.red :
               !enabled || readOnly || minored ?
                   EaStyle.Colors.themeForegroundMinor :
                   activeFocus || selected || hovered ?
                       EaStyle.Colors.themeForegroundHovered :
                       EaStyle.Colors.themeForeground
    Behavior on color { EaAnimations.ThemeChange {} }
}
