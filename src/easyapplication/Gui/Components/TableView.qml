import QtQuick
import QtQuick.Controls

import EasyApp.Gui.Globals as EaGlobals
import EasyApp.Gui.Style as EaStyle
import EasyApp.Gui.Animations as EaAnimations
import EasyApp.Gui.Elements as EaElements
import EasyApp.Gui.Components as EaComponents


ListView {
    id: listView

    property alias defaultInfoText: defaultInfoLabel.text
    property bool showHeader: true
    property bool tallRows: false
    property var headerLabelItems: headerItem.children[0].children
    property int contentItemChildrenLength: contentItem.children.length
    property int maxRowCountShow: EaStyle.Sizes.tableMaxRowCountShow
    property int tableRowHeight: tallRows ?
                                     1.5 * EaStyle.Sizes.tableRowHeight :
                                     EaStyle.Sizes.tableRowHeight

    enabled: count > 0

    width: EaStyle.Sizes.sideBarContentWidth
    height: count === 0 ?
                2 * EaStyle.Sizes.tableRowHeight :
                showHeader ?
                    tableRowHeight * (Math.min(count, maxRowCountShow) + 1 ) :
                    tableRowHeight * (Math.min(count, maxRowCountShow))

    clip: true
    headerPositioning: ListView.OverlayHeader
    boundsBehavior: Flickable.StopAtBounds

    onHeaderLabelItemsChanged: setWidthOfFlexibleColumnForHeader()
    onContentItemChildrenLengthChanged: widthAndAlignmentChangeTimer.start()

    // Empty header row
    //header: EaComponents.TableViewHeader {}

    // Empty content rows
    //delegate: EaComponents.TableViewDelegate {}

    // fixes an issue of clicks not registering right after scroll
    pressDelay: 10

    // Table border
    Rectangle {
        anchors.fill: listView
        color: "transparent"
        antialiasing: true
        border.color: EaStyle.Colors.appBarComboBoxBorder
        Behavior on border.color { EaAnimations.ThemeChange {} }
    }

    // Default info, if no rows added
    Rectangle {
        visible: listView.count === 0
        width: listView.width
        height: EaStyle.Sizes.tableRowHeight * 2
        color: EaStyle.Colors.themeBackground

        Behavior on color { EaAnimations.ThemeChange {} }

        EaElements.Label {
            id: defaultInfoLabel

            anchors.verticalCenter: parent.verticalCenter
            leftPadding: EaStyle.Sizes.fontPixelSize
        }
    }

    // Width and alignment change timer
    Timer {
        id: widthAndAlignmentChangeTimer
        interval: 10
        onTriggered: setAllColumnsWidthAndAlignment()
    }

    // ScrollBar
    ScrollBar.vertical: EaElements.ScrollBar {
        topPadding: topInset

        interactive: true
        topInset: listView.headerItem ? listView.headerItem.height : 0

        policy: ScrollBar.AsNeeded
    }

    // Logic

    function flexibleColumnWidth() {
        let fixedColumnsWidth = 0
        for (let item of headerLabelItems) {
            if (!item.flexibleWidth) {
                fixedColumnsWidth += item.width
            }
        }
        const allColumnWidth = listView.width
        const spacingWidth = EaStyle.Sizes.tableColumnSpacing * (headerLabelItems.length - 1)
        const borderThickness = EaStyle.Sizes.borderThickness * 2
        const flexibleColumnWidth = allColumnWidth -
                                  fixedColumnsWidth -
                                  spacingWidth -
                                  borderThickness
        return flexibleColumnWidth
    }

    function setWidthOfFlexibleColumnForHeader() {
        for (let item of headerLabelItems) {
            if (item.flexibleWidth) {
                item.width = flexibleColumnWidth()
            }
        }
    }

    function setAllColumnsWidthAndAlignment() {
        for (let item of contentItem.children) {
            // Check for TableViewDelegate using explicit property
            if (item.toString().startsWith('TableViewDelegate_QMLTYPE')) {
                const rowElement = item.children[0]
                if (rowElement && rowElement.children) {
                    for (let columnIndex in rowElement.children) {
                        if (columnIndex < headerLabelItems.length) {
                            rowElement.children[columnIndex].width = headerLabelItems[columnIndex].width
                            if (typeof rowElement.children[columnIndex].horizontalAlignment !== 'undefined') {
                                rowElement.children[columnIndex].horizontalAlignment = headerLabelItems[columnIndex].horizontalAlignment
                            }
                        }
                    }
                }
            }
        }
    }

}
