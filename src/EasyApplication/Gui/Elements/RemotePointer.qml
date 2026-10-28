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

    // Keep the input/placement geometry fixed. The original circle grows around
    // its center in the scene graph instead of relaying out on every pulse frame.
    width: minSize
    height: minSize
    radius: minSize / 2
    transformOrigin: Item.Center

    color: "coral"
    opacity: 0

    OpacityAnimator {
        id: showAnimation
        target: pointer
        to: pointer.minOpacity
        duration: pointer.showHideDuration
    }

    OpacityAnimator {
        id: hideAnimation
        target: pointer
        to: 0
        duration: pointer.showHideDuration
    }

    ParallelAnimation {
        id: moveAnimation
        XAnimator { target: pointer; to: pointer.posX - pointer.minSize / 2; duration: pointer.moveDuration; easing.type: Easing.InOutCubic }
        YAnimator { target: pointer; to: pointer.posY - pointer.minSize / 2; duration: pointer.moveDuration; easing.type: Easing.InOutCubic }
    }

    // Animator-only groups can run on Qt Quick's rendering thread. A basic
    // render loop still works, but this is not a substitute for responsive GUI work.
    SequentialAnimation {
        id: clickAnimation
        ParallelAnimation {
            ScaleAnimator { target: pointer; from: 1; to: pointer.maxSize / Math.max(1, pointer.minSize); duration: pointer.pressDuration; easing.type: Easing.InOutCubic }
            OpacityAnimator { target: pointer; from: pointer.minOpacity; to: pointer.maxOpacity; duration: pointer.pressDuration; easing.type: Easing.InOutCubic }
        }
        ParallelAnimation {
            ScaleAnimator { target: pointer; from: pointer.maxSize / Math.max(1, pointer.minSize); to: 1; duration: pointer.clickRelaxation; easing.type: Easing.InOutCubic }
            OpacityAnimator { target: pointer; from: pointer.maxOpacity; to: pointer.minOpacity; duration: pointer.clickRelaxation; easing.type: Easing.InOutCubic }
        }
    }

    function move(x, y) {
        clickAnimation.stop()
        pointer.scale = 1
        pointer.posX = x
        pointer.posY = y
        moveAnimation.restart()
    }

    function click() {
        showAnimation.stop()
        hideAnimation.stop()
        moveAnimation.stop()
        pointer.x = pointer.posX - pointer.minSize / 2
        pointer.y = pointer.posY - pointer.minSize / 2
        clickAnimation.restart()
    }

    function show() {
        hideAnimation.stop()
        clickAnimation.stop()
        moveAnimation.stop()
        pointer.scale = 1
        pointer.x = pointer.posX - pointer.minSize / 2
        pointer.y = pointer.posY - pointer.minSize / 2
        showAnimation.restart()
    }

    function hide() {
        showAnimation.stop()
        clickAnimation.stop()
        hideAnimation.restart()
    }
}
