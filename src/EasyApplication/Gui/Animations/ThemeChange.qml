import QtQuick

import EasyApplication.Gui.Style as EaStyle

PropertyAnimation {
    duration: EaStyle.Times.themeChange
    alwaysRunToEnd: true
    easing.type: Easing.OutQuint
}
