import QtQuick
import QtQuick.Templates as T
import QtQuick.Controls
import QtQuick.Controls.impl

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Animations as EaAnimations
import EasyApplication.Gui.Elements as EaElements


EaElements.TextField {
    id: control

    property string units: ''
    property string title: ''

    readonly property bool hasUnits: units.length > 0
    readonly property real unitsSpacing: EaStyle.Sizes.fontPixelSize * 0.5

    leftPadding: padding
    rightPadding: padding + (hasUnits ? unitsSpacing + unitsPlaceholder.implicitWidth : 0)

    topInset: title === '' ? 0 : EaStyle.Sizes.fontPixelSize * 1.5
    topPadding: topInset + padding

    implicitWidth: Math.max(
        EaStyle.Sizes.fontPixelSize * 10,
        Math.max(contentWidth, implicitPlaceholderWidth) + leftPadding + rightPadding,
        titleLabel.implicitWidth + leftPadding + padding
    )
    placeholderText: ''

    EaElements.Label {
        id: titleLabel

        anchors.left: control.left
        anchors.leftMargin: control.leftPadding

        enabled: false
        text: control.title
    }

    PlaceholderText {
        id: unitsPlaceholder

        visible: control.hasUnits

        anchors.right: control.right
        anchors.rightMargin: control.padding
        anchors.baseline: control.baseline

        leftPadding: 0
        rightPadding: 0

        font: control.font
        color: control.placeholderTextColor

        text: control.units
        textFormat: Text.RichText
    }
}
