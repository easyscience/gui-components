import QtQuick
import QtQuick.Controls
import QtMultimedia
import QtTest

import EasyApplication.Gui.Style as EaStyle
import EasyApplication.Gui.Globals as EaGlobals
import EasyApplication.Gui.Elements as EaElements

Item {
    id: rc

    property string audioDir: ""
    property bool audioEnabled: false
    property bool isTestMode: false

    parent: Overlay.overlay
    anchors.fill: parent
    z: 9999

    /*
    focus: true
    onFocusChanged: {
        focus = true
        print("*** rc focus", focus)
    }

    Keys.onPressed: {
        print("--event.key--", event.key)
        if (event.key === Qt.Key_Escape) {
            visible = false
        } else {
            event.accepted = false
        }
    }
    */

    TestUtil { id: util }
    TestResult { id: result }
    TestEvent { id: event }

    EaElements.RemotePointer { id: pointer }

    EaElements.Button {
        visible: rc.visible

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: EaStyle.Sizes.statusBarHeight - 0.5 * height

        height: EaStyle.Sizes.sideBarButtonHeight
        padding: EaStyle.Sizes.fontPixelSize

        background: Rectangle {
            radius: 2
            color: EaStyle.Colors.mainContentBackground
            opacity: 0.5

            layer.enabled: true
            layer.effect: EaElements.ToolTipShadow {
                shadowColor: EaStyle.Colors.toolTipBorder
            }
        }

        text: qsTr("Stop tutorial")
        onClicked: {
            rc.hidePointer()
            rc.visible = false
        }
    }

    /*
    Audio {
        id: audio

        onDurationChanged: {
            play()
            wait(audio.duration)
        }
    }
    */

    Timer {
        id: saveScreenshots

        property int i: 1
        property int fps: EaGlobals.Vars.projectConfig.ci.app.tutorials.video.fps
        property string screenshotsDir: EaGlobals.Vars.projectConfig.ci.project.subdirs.screenshots

        running: EaGlobals.Vars.saveScreenshotsRunning

        interval: 1000 / fps
        repeat: true

        onTriggered: {
            const fname = ("00000" + i++).slice(-6)
            const fpath = screenshotsDir + "/" + fname + ".png"
            saveScreenshot(rc, fpath)
        }
    }

    // Controller Logic

    function say(text) {
        if (!visible)
            return
        if (!audioEnabled)
            return
        if (text === "")
            return
        const fileName = text.replace(/ /g, "_")
        audio.source = `${audioDir}/${fileName}.mp3`
        wait(1000) // Needed for smooth pointer movement
    }

    function saveScreenshot(item, path) {
        if (!visible)
            return
        const image = result.grabImage(item)
        image.save(path)
    }

    function wait(ms) {
        if (!visible)
            return
        result.wait(ms)
    }

    function posToCenter() {
        if (!visible)
            return
        pointer.posX = rc.width / 2 - pointer.minSize / 2
        pointer.posY = rc.height / 2 - pointer.minSize / 2
        mouseMove(rc)
    }

    function showPointer() {
        if (!visible)
            return
        pointer.show()
        wait(pointer.showHideDuration)
    }

    function hidePointer() {
        if (!visible)
            return
        pointer.hide()
        wait(pointer.showHideDuration)
    }

    function pointerMove(item, x, y, delay, buttons) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }

        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (delay === undefined)
            delay = -1
        if (buttons === undefined)
            buttons = Qt.NoButton

        const pos = item.mapToItem(null, x, y)
        pointer.move(pos.x, pos.y)
    }

    function mousePress(item, x, y, button, modifiers, delay) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }

        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (button === undefined)
            button = Qt.LeftButton
        if (modifiers === undefined)
            modifiers = Qt.NoModifier
        if (delay === undefined)
            delay = -1

        //event.mouseMove(item, x, y, button, modifiers, delay)
        //event.mouseRelease(item, x, y, button, modifiers, delay)
        event.mousePress(item, x, y, button, modifiers, delay)
        pointer.click()
    }

    function mouseRelease(item, x, y, button, modifiers, delay) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }

        if (x === undefined)
            x = item.width / 2
        if (y === undefined)
            y = item.height / 2
        if (button === undefined)
            button = Qt.LeftButton
        if (modifiers === undefined)
            modifiers = Qt.NoModifier
        if (delay === undefined)
            delay = -1

        event.mouseRelease(item, x, y, button, modifiers, delay)
    }

    function mouseClick(item, x, y) {
        if (!visible)
            return
        pointerMove(item, x, y)
        wait(pointer.moveDuration)
        mouseMove(item)

        wait(pointer.clickRelaxation)

        mousePress(item, x, y)
        wait(pointer.pressDuration)
        mouseRelease(item, x, y)
        wait(pointer.clickRelaxation - pointer.pressDuration)

        wait(pointer.clickRelaxation)
    }

    function mouseLeftClickSilent(item) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.LeftButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseClick(item, x, y, button, modifiers, delay)
    }

    function mouseRightClickSilent(item) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.RightButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseClick(item, x, y, button, modifiers, delay)
    }

    function mouseMove(item) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const button = Qt.NoButton
        const delay = -1
        const modifiers = Qt.NoModifier
        event.mouseMove(item, x, y, button, modifiers, delay)
    }

    function mouseWheel(item) {
        if (!visible)
            return
        if (item === undefined) {
            print("Undefined item")
            return
        }
        const x = item.width / 2
        const y = item.height / 2
        const xDelta = 0
        const yDelta = 120  // 120 units * 1/8 = 15 degrees
        const button = Qt.NoButton
        const modifiers = Qt.NoModifier
        const delay = -1

        event.mouseWheel(item, x, y, button, modifiers, xDelta, yDelta, delay) // ?
    }

    function typeText(text) {
        if (!visible)
            return
        const modifiers = Qt.NoModifier
        const delay = -1
        for (const c of text) {
            event.keyClickChar(c, modifiers, delay)
            wait(100)
        }
    }

    function deleteCharacters(count) {
        if (!visible)
            return
        const modifiers = Qt.NoModifier
        const delay = -1
        const key = Qt.Key_Backspace//Key_Clear//Key_Delete
        while (count > 0) {
            event.keyClick(key, modifiers, delay)
            wait(100)
            count -= 1
        }
    }

    function keyClick(key) {
        if (!visible)
            return
        const modifiers = Qt.NoModifier
        const delay = -1
        event.keyClick(key, modifiers, delay)
        wait(500)
    }

    function basename(fullpath) {
        return fullpath.substring(fullpath.lastIndexOf('/') + 1)
    }

    function compare(actual, expected) {
        const file = basename(util.callerFile())
        const line = util.callerLine()

        if (typeof actual === 'undefined') {
            return(`FAIL in ${file}:${line}: Actual object or property is undefined.`)
        }

        const success = qtest_compareInternal(actual, expected)
        if (success) {
            return(`OK   in ${basename(util.callerFile())}:${util.callerLine()}`)
        } else {
            const actualStr = result.stringify(actual)
            const expectedStr = result.stringify(expected)
            return(`FAIL in ${file}:${line}: '${actualStr}' != '${expectedStr}'`)
        }
    }

    /*! \internal */
    // Determine what is o.
    // Discussions and reference: http://philrathe.com/articles/equiv
    // Test suites: http://philrathe.com/tests/equiv
    // Author: Philippe Rathé <prathe@gmail.com>
    function qtest_typeof(o) {
        if (typeof o === "undefined") {
            return "undefined";

        // consider: typeof null === object
        } else if (o === null) {
            return "null";

        } else if (o.constructor === String) {
            return "string";

        } else if (o.constructor === Boolean) {
            return "boolean";

        } else if (o.constructor === Number) {

            if (isNaN(o)) {
                return "nan";
            } else {
                return "number";
            }
        // consider: typeof [] === object
        } else if (o instanceof Array) {
            return "array";

        // consider: typeof new Date() === object
        } else if (o instanceof Date) {
            return "date";

        // consider: /./ instanceof Object;
        //           /./ instanceof RegExp;
        //          typeof /./ === "function"; // => false in IE and Opera,
        //                                          true in FF and Safari
        } else if (o instanceof RegExp) {
            return "regexp";

        } else if (typeof o === "object") {
            if ("mapFromItem" in o && "mapToItem" in o) {
                return "declarativeitem";  // @todo improve detection of declarative items
            } else if ("x" in o && "y" in o && "z" in o) {
                return "vector3d"; // Qt 3D vector
            }
            return "object";
        } else if (o instanceof Function) {
            return "function";
        } else {
            return undefined;
        }
    }

    /*! \internal */
    // Test for equality
    // Large parts contain sources from QUnit or http://philrathe.com
    // Discussions and reference: http://philrathe.com/articles/equiv
    // Test suites: http://philrathe.com/tests/equiv
    // Author: Philippe Rathé <prathe@gmail.com>
    function qtest_compareInternal(act, exp) {
        var success = false;
        if (act === exp) {
            success = true; // catch the most you can
        } else if (act === null || exp === null || typeof act === "undefined" || typeof exp === "undefined") {
            success = false; // don't lose time with error prone cases
        } else {
            var typeExp = qtest_typeof(exp), typeAct = qtest_typeof(act)
            if (typeExp !== typeAct) {
                // allow object vs string comparison (e.g. for colors)
                // else break on different types
                if ((typeExp === "string" && (typeAct === "object") || typeAct == "declarativeitem")
                 || ((typeExp === "object" || typeExp == "declarativeitem") && typeAct === "string")) {
                    success = (act == exp)
                }
            } else if (typeExp === "string" || typeExp === "boolean" ||
                       typeExp === "null" || typeExp === "undefined") {
                if (exp instanceof act.constructor || act instanceof exp.constructor) {
                    // to catch short annotaion VS 'new' annotation of act declaration
                    // e.g. var i = 1;
                    //      var j = new Number(1);
                    success = (act == exp)
                } else {
                    success = (act === exp)
                }
            } else if (typeExp === "nan") {
                success = isNaN(act);
            } else if (typeExp === "number") {
                // Use act fuzzy compare if the two values are floats
                if (Math.abs(act - exp) <= 0.00001) {
                    success = true
                }
            } else if (typeExp === "array") {
                success = qtest_compareInternalArrays(act, exp)
            } else if (typeExp === "object") {
                success = qtest_compareInternalObjects(act, exp)
            } else if (typeExp === "declarativeitem") {
                success = qtest_compareInternalObjects(act, exp) // @todo improve comparison of declarative items
            } else if (typeExp === "vector3d") {
                success = (Math.abs(act.x - exp.x) <= 0.00001 &&
                           Math.abs(act.y - exp.y) <= 0.00001 &&
                           Math.abs(act.z - exp.z) <= 0.00001)
            } else if (typeExp === "date") {
                success = (act.valueOf() === exp.valueOf())
            } else if (typeExp === "regexp") {
                success = (act.source === exp.source && // the regex itself
                           act.global === exp.global && // and its modifers (gmi) ...
                           act.ignoreCase === exp.ignoreCase &&
                           act.multiline === exp.multiline)
            }
        }
        return success
    }

    /*! \internal */
    function qtest_compareInternalObjects(act, exp) {
        var i;
        var eq = true; // unless we can proove it
        var aProperties = [], bProperties = []; // collection of strings

        // comparing constructors is more strict than using instanceof
        if (act.constructor !== exp.constructor) {
            return false;
        }

        for (i in act) { // be strict: don't ensures hasOwnProperty and go deep
            aProperties.push(i); // collect act's properties
            if (!qtest_compareInternal(act[i], exp[i])) {
                eq = false;
                break;
            }
        }

        for (i in exp) {
            bProperties.push(i); // collect exp's properties
        }

        if (aProperties.length == 0 && bProperties.length == 0) { // at least a special case for QUrl
            return eq && (JSON.stringify(act) == JSON.stringify(exp));
        }

        // Ensures identical properties name
        return eq && qtest_compareInternal(aProperties.sort(), bProperties.sort());

    }

    /*! \internal */
    function qtest_compareInternalArrays(actual, expected) {
        if (actual.length != expected.length) {
            return false
        }

        for (var i = 0, len = actual.length; i < len; i++) {
            if (!qtest_compareInternal(actual[i], expected[i])) {
                return false
            }
        }

        return true
    }

}
