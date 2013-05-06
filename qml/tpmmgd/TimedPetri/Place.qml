import QtQuick 2.0

Item
{
    property int tokens: 0
    property int bars: 0
    property int maxMarks: 8
    property bool isPlace: true
    property string color: 'black'
    property int centerX: x + width / 2
    property int centerY: y + height / 2
    property int radius: rect.radius
    property bool focusGone: false
    property var collisionPoints: {
        var cp1 = []; cp1[0] = x; cp1[1] = y
        var cp2 = []; cp2[0] = x + width; cp2[1] = y
        var cp3 = []; cp3[0] = x; cp3[1] = y + height
        var cp4 = []; cp4[0] = x + width; cp4[1] = y + height
        return [cp1, cp2, cp3, cp4]
    }

    property string inbound
    property string outbound
    property string labelText: label.text

    property CurveControl ictrl
    property CurveControl octrl

    property bool focused: false
    property bool beingDragged: mousearea.drag.active
    property FocusHandler focushandler
    property IndexHandler indexhandler
    signal clicked (variant mouse)

    property int oldX: 0
    property int oldY: 0

    id: place
    width: 50
    height: 50
    state: 'squqozen'
    z: 2

    function setCtrl(ix, iy, ox, oy){
        if(ictrl) {
            ictrl.x = ix
            ictrl.y = iy
        }

        if(octrl) {
            octrl.x = ox
            octrl.y = oy
        }
    }

    function shiftInCtrl(dX, dY) {
        if(ictrl) {
            ictrl.x += dX
            ictrl.y += dY
        }
    }

    function shiftOutCtrl(dX, dY) {
        if(octrl) {
            octrl.x += dX
            octrl.y += dY
        }
    }

    function getPredecessor() {
        if(!inbound) return
        var predecessor
        predecessor = indexhandler.connection(inbound)
        .getTransition()
        .objectName
        return predecessor
    }

    function getSuccessor() {
        if(!outbound) return
        var successor
        successor = indexhandler.connection(outbound)
        .getTransition()
        .objectName
        return successor
    }

    function setLabel(text) {
        label.text = text
    }

    function sgn(n) {
        return n?n<0?-1:1:0
    }

    function borderPoint(x, y) {
        var angle = Math.atan2(x - centerX, y - centerY)

        var dX = (rect.radius + 3) * Math.sin(angle)
        var dY = (rect.radius + 3) * Math.cos(angle)

        return [centerX + dX, centerY + dY, angle]
    }

    function unfocus(union) {
        focused = false
    }

    function focus(union) {
        focused = true
    }

    function parallelShift() {
        if(beingDragged) {
            var dX = x - oldX
            var dY = y - oldY
            focushandler.shiftAll(dX, dY)
        }
        oldX = x
        oldY = y
    }

    states: [
        State {
            name: 'squqozen'
            PropertyChanges {
                target: place
                scale: 0.1
            }
        },
        State {
            name: 'rasquqozen'
            PropertyChanges {
                target: place
                scale: 1
            }
        }
    ]

    transitions: [
        Transition {
            from: "squqozen"
            to: "rasquqozen"
            NumberAnimation { duration: 250; properties: "scale"; easing.type: Easing.InQuint }
        },
        Transition {
            from: "rasquqozen"
            to: "squqozen"
            NumberAnimation { duration: 250; properties: "scale"; easing.type: Easing.OutQuint }
        }
    ]

    onXChanged: {
        if(place.state == 'squqozen') {
            place.state = 'rasquqozen'
        }

        parallelShift()
    }
    onYChanged: {
        if(place.state == 'squqozen') {
            place.state = 'rasquqozen'
        }

        if(outbound) {
            var transition_outbounded = indexhandler.connection(outbound).getTransition()
            transition_outbounded.sortInbound()
        }

        if(inbound) {
            var transition_inbounded = indexhandler.connection(inbound).getTransition()
            transition_inbounded.sortOutbound()
        }

        parallelShift()
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        radius: width * 0.5
        border.color: focused ? '#e74c3c' : place.color
        border.width: 2
        color: 'white'
        antialiasing: true

        Grid {
            anchors.centerIn: parent
            anchors.margins: 4
            spacing: 2
            Repeater {
                model: place.tokens
                Token {}
            }
            Repeater {
                model: place.bars
                Bar {}
            }
        }
    }

    Text {
        id: label
        anchors.top: rect.bottom
        anchors.horizontalCenter: rect.horizontalCenter
        anchors.topMargin: 5
        color: focused ? '#e74c3c' : place.color
        font.italic: true
    }

    function addToLabel(ch) {
        label.text = label.text + ch
    }

    function backspaceLabel() {
        label.text = label.text.substr(0, label.text.length - 1)
    }

    MouseArea {
        id: mousearea

        function contains(x, y) {
            var d = (width / 2);
            var dx = (x - width / 2);
            var dy = (y - height / 2);
            return (d * d > dx * dx + dy * dy);
        }

        anchors.fill: parent
        drag.target: place
        onDoubleClicked: {
            if(mouse.modifiers === Qt.NoModifier) {
                if(place.tokens + place.bars < place.maxMarks) ++place.tokens
            } else if(mouse.modifiers === Qt.ShiftModifier) {
                if(place.tokens > 0) --place.tokens
            } else if(mouse.modifiers === Qt.ControlModifier) {
                if(place.tokens + place.bars < place.maxMarks) ++place.bars
            } else if(mouse.modifiers === (Qt.ControlModifier | Qt.ShiftModifier)) {
                if(place.bars > 0) --place.bars
            }
        }

        onClicked: {
            mouse.accepted = contains(mouse.x, mouse.y)
            if(mouse.accepted && !place.focusGone) {
                focushandler.addFocusedClick(place,
                                             mouse.modifiers === Qt.ShiftModifier)
            }
        }

        onReleased: {
            drag.target = place
        }

        onPressed: {
            place.focusGone = false

            mouse.accepted = contains(mouse.x, mouse.y)
            if(mouse.accepted) {
                var withShift = (mouse.modifiers === Qt.ShiftModifier)
                if(!focused && focushandler.count() > 1 && !withShift) {
                    focushandler.clearFocused()
                }

                focushandler.addFocusedPress(place, withShift)
            }

            if(mouse.button === Qt.LeftButton &&
                    mouse.modifiers === Qt.AltModifier) {
                var newPlace = addCenteredPlace(parent.x + mouse.x, parent.y + mouse.y)
                focushandler.addFocusedPress(newPlace, false)
                drag.target = newPlace
                place.focusGone = true
            }
        }
    }
}
