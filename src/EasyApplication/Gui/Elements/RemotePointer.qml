import QtQuick


Rectangle {
    id: pointer

    property int moveDuration: 500
    property int pressDuration: 100
    property int clickRelaxation: 500
    property int showHideDuration: 500

    property int posX: 0
    property int posY: 0
    property int maxSize: 30
    property int minSize: 14

    property real minOpacity: 0.50
    property real maxOpacity: 0.75

    width: minSize
    height: minSize
    radius: minSize/2

    color: "coral"
    opacity: 0

    ParallelAnimation {
        id: showAnimation
        PropertyAction { target: pointer; property: "x"; value: pointer.posX - pointer.width/2 }
        PropertyAction { target: pointer; property: "y"; value: pointer.posY - pointer.height/2 }
        PropertyAnimation { target: pointer; property: "opacity"; to: pointer.minOpacity; duration: pointer.showHideDuration }
    }

    ParallelAnimation {
        id: hideAnimation
        PropertyAnimation { target: pointer; property: "opacity"; to: 0; duration: pointer.showHideDuration }
    }

    ParallelAnimation {
        id: moveAnimation
        PropertyAnimation { target: pointer; property: "x"; to: pointer.posX - pointer.minSize/2; duration: pointer.moveDuration; easing.type: Easing.InOutCubic }
        PropertyAnimation { target: pointer; property: "y"; to: pointer.posY - pointer.minSize/2; duration: pointer.moveDuration; easing.type: Easing.InOutCubic }
        PropertyAnimation { target: pointer; property: "width"; to: pointer.minSize; duration: pointer.moveDuration; easing.type: Easing.InOutCubic }
        PropertyAnimation { target: pointer; property: "height"; to: pointer.minSize; duration: pointer.moveDuration; easing.type: Easing.InOutCubic }
        PropertyAnimation { target: pointer; property: "radius"; to: pointer.minSize/2; duration: pointer.moveDuration; easing.type: Easing.InOutCubic }
    }

    SequentialAnimation {
        id: clickAnimation
        ParallelAnimation {
            PropertyAction { target: pointer; property: "x"; value: pointer.posX - pointer.maxSize/2 }
            PropertyAction { target: pointer; property: "y"; value: pointer.posY - pointer.maxSize/2 }
            PropertyAction { target: pointer; property: "width"; value: pointer.maxSize }
            PropertyAction { target: pointer; property: "height"; value: pointer.maxSize }
            PropertyAction { target: pointer; property: "radius"; value: pointer.maxSize/2 }
            PropertyAction { target: pointer; property: "opacity"; value: pointer.maxOpacity }
        }
        ParallelAnimation {
            PropertyAnimation { target: pointer; property: "x"; to: pointer.posX - pointer.minSize/2; duration: pointer.clickRelaxation; easing.type: Easing.InOutCubic }
            PropertyAnimation { target: pointer; property: "y"; to: pointer.posY - pointer.minSize/2; duration: pointer.clickRelaxation; easing.type: Easing.InOutCubic }
            PropertyAnimation { target: pointer; property: "width"; to: pointer.minSize; duration: pointer.clickRelaxation; easing.type: Easing.InOutCubic }
            PropertyAnimation { target: pointer; property: "height"; to: pointer.minSize; duration: pointer.clickRelaxation; easing.type: Easing.InOutCubic }
            PropertyAnimation { target: pointer; property: "radius"; to: pointer.minSize/2; duration: pointer.clickRelaxation; easing.type: Easing.InOutCubic }
            PropertyAnimation { target: pointer; property: "opacity"; to: pointer.minOpacity; duration: pointer.clickRelaxation; easing.type: Easing.InOutCubic }
        }
    }

    // Pointer Logic

    function move(x, y) {
        pointer.posX = x
        pointer.posY = y
        moveAnimation.start()
        //wait(pointer.moveDuration)
    }

    function click() {
        clickAnimation.start()
        //wait(pointer.clickRelaxation)
    }

    function show() {
        showAnimation.start()
    }

    function hide() {
        hideAnimation.start()
    }

}
