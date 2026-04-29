import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Elements as EaElements


EaElements.Dialog {
    property string appIconPath: ""
    property string appUrl: ""
    property string appPrefixName: ""
    property string appSuffixName: ""
    property string appVersion: ""
    property string appDate: ""
    property string eulaUrl: ""
    property string oslUrl: ""
    property string description: ""
    property var developerIcons: []
    property string developerYearsFrom: ""
    property string developerYearsTo: ""

    property string commit: ''
    property string commitUrl: ''
    property string branch: ''
    property string branchUrl: ''

    title: qsTr("About")

    standardButtons: Dialog.Ok

    Column {
        spacing: EaStyle.Sizes.fontPixelSize * 2.0

        // Application icon, name, version container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: -EaStyle.Sizes.fontPixelSize * 0.25

            Row {
                // Application logo
                EaElements.LinkedImage {
                    anchors.verticalCenter: parent.verticalCenter
                    height: EaStyle.Sizes.fontPixelSize * 3.5
                    source: appIconPath
                    link: appUrl
                }

                // Application name
                EaElements.Label {
                    anchors.verticalCenter: parent.verticalCenter
                    bottomPadding: EaStyle.Sizes.fontPixelSize * 0.5
                    verticalAlignment: Text.AlignVCenter
                    text: " " + appPrefixName
                    font.family: EaStyle.Fonts.thirdFontFamily
                    font.weight: Font.Light
                    font.pixelSize: EaStyle.Sizes.fontPixelSize * 3
                }

                EaElements.Label {
                    anchors.verticalCenter: parent.verticalCenter
                    bottomPadding: EaStyle.Sizes.fontPixelSize * 0.5
                    text: appSuffixName
                    font.family: EaStyle.Fonts.thirdFontFamily
                    font.weight: Font.DemiBold
                    font.pixelSize: EaStyle.Sizes.fontPixelSize * 3
                }
            }

            // Application version
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: branch && branch !== 'master'
                      ? qsTr(`Version <a href="${commitUrl}">${appVersion}-${commit}</a> (${appDate})`)
                      : qsTr(`Version ${appVersion} (${appDate})`)
            }

            // Github branch
            EaElements.Label {
                visible: branch && branch !== 'master'
                topPadding: EaStyle.Sizes.fontPixelSize * 0.5
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr(`Branch <a href="${branchUrl}">${branch}</a>`)
            }
        }

        // EULA and licences container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            // EULA
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr(`<a href="${eulaUrl}">End User Licence Agreement</a>`)
            }

            // Licences
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr(`<a href="${oslUrl}">Dependent Open Source Licenses</a>`)
            }
        }

        // Description container
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: EaStyle.Sizes.fontPixelSize * 0.5

            // About text
            EaElements.Label {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: description
            }

            // Developer icons
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: EaStyle.Sizes.fontPixelSize
                Repeater {
                    model: developerIcons.length
                    EaElements.LinkedImage {
                        anchors.verticalCenter: parent.verticalCenter
                        height: EaStyle.Sizes.fontPixelSize * developerIcons[index].heightScale
                        source: developerIcons[index].icon
                        link: developerIcons[index].url
                    }
                }
            }
        }

        // Footer
        EaElements.Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: `© ${developerYearsFrom}-${developerYearsTo} • All rights reserved`
        }
    }

}

