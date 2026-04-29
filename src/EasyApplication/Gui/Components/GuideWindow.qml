import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts 1.12

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements

import Gui.Globals as ExGlobals

Item {
    id: item

    property var container
    property alias text: tooltip.text

    property int appBarCurrentIndex: EaGlobals.Vars.appBarCurrentIndex
    onAppBarCurrentIndexChanged: container.setCurrentIndex(0)

    EaElements.ToolTip {
        id: tooltip

        parent: item.parent
        visible: !EaGlobals.Vars.showAppPreferencesDialog &&
                 EaGlobals.Vars.showUserGuides &&
                 appBarCurrentIndex === container.appBarCurrentIndex &&
                 container.currentIndex === indexOf(container.contentModel.children, item)

        // Top dots
        guidesCount: container.count
        currentGuideIndex: container.currentIndex

        // Bottom buttons
        controlButtons: [
            EaElements.Button {
                text: qsTr("Previous")
                enabled: container.currentIndex > 0
                onClicked: container.decrementCurrentIndex()
            },

            EaElements.Button {
                text: qsTr("Disable")
                onClicked: EaGlobals.Vars.showUserGuides = false

                Component.onCompleted: {
                    if (typeof ExGlobals.Vars.userGuidesLastDisableButton === 'undefined') {
                        ExGlobals.Vars.userGuidesLastDisableButton = this
                    }
                }
            },

            EaElements.Button {
                objectName: tooltip.text
                text: qsTr("Next")
                enabled: container.currentIndex < container.count - 1
                onClicked: container.incrementCurrentIndex()

                Component.onCompleted: ExGlobals.Vars.userGuidesNextButtons[container.appBarCurrentIndex].unshift(this)
            }
        ]

        onTextChanged: ExGlobals.Vars.userGuidesTextList[container.appBarCurrentIndex].unshift(text)
    }

    // Logic

    function indexOf(model, item) {
        for (let i in model) {
            if (model[i] === item) {
                return parseInt(i)
            }
        }
        return -1
    }
}
