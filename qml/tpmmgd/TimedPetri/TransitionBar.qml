import QtQuick 2.0
import 'TransitionStore.js' as Transitions

Item
{
    property bool isTransition: true
    property bool isHorizontal: (state === 'horizontal') ? true : false
    property string color: 'black'
    property int centerX: x + width / 2
    property int centerY: y + height / 2
    property bool focused: false
    property bool beingDragged: mousearea.drag.active
    property bool focusGone: false
    property FocusHandler focushandler
    property IndexHandler indexhandler

    property var inbound: Transitions.inbound
    property var outbound: Transitions.outbound
    property string labelText: label.text

    property var collisionPoints: {
        var cp1 = []; cp1[0] = x; cp1[1] = y
        var cp2 = []; cp2[0] = x + width; cp2[1] = y
        var cp3 = []; cp3[0] = x; cp3[1] = y + height
        var cp4 = []; cp4[0] = x + width; cp4[1] = y + height
        return [cp1, cp2, cp3, cp4]
    }

    function resetControlPoints() {
        var place
        for(var ci in inbound) {
            place = indexhandler.connection(inbound[ci]).getPlace()
            if(place.ictrl) place.ictrl.reset()
            if(place.octrl) place.octrl.reset()
        }

        for(var co in outbound) {
            place = indexhandler.connection(outbound[co]).getPlace()
            if(place.ictrl) place.ictrl.reset()
            if(place.octrl) place.octrl.reset()
        }
    }

    function shiftControlPoints(dX, dY) {
        for(var ci in inbound) {
            indexhandler.connection(inbound[ci]).getPlace().shiftInCtrl(dX, dY)
        }

        for(var co in outbound) {
            indexhandler.connection(outbound[co]).getPlace().shiftOutCtrl(dX, dY)
        }
    }

    function setLabel(text) {
        label.text = text
    }

    function sgn(n) {
        return n?n<0?-1:1:0
    }

    function borderPoint(x, y, connection) {
        var isInbound = connection.isTransitionInbound
        var offset = 3
        var offsetH = 8

        // line 2 - variant vertical inbound
        var line21 = [
                    transition.x - offset , // x3 line2[0]
                    transition.y, // y3 line2[1]
                    transition.x - offset, // x4 line2[2]
                    transition.y + transition.height // y4 line2[3]
                ]

        // line 3 - variant vertical outbound
        var line22 = [
                    transition.x + width + offset, // x3 line2[0]
                    transition.y, // y3 line2[1]
                    transition.x + width + offset, // x4 line2[2]
                    transition.y + transition.height, // y4 line2[3]
                ]

        // line 2 - variant horizontal inbound
        var line23 = [
                    transition.x - transition.height / 2 + transition.width / 2, // x3 line2[0]
                    transition.y + transition.height / 2 - transition.width - offset, // y3 line2[1]
                    transition.x - transition.height / 2 + transition.width / 2 + transition.height, // x4 line2[2]
                    transition.y + transition.height / 2 - offset // y4 line2[3]
                ]

        // line 3 - variant horizontal outbound
        var line24 = [
                    transition.x - transition.height / 2 + transition.width / 2, // x3 line2[0]
                    transition.y + transition.height / 2 + offsetH, // y3 line2[1]
                    transition.x - transition.height / 2 + transition.width / 2 + transition.height, // x4 line2[2]
                    transition.y + transition.height / 2 + transition.width + offsetH // y4 line2[3]
                ]

        // line 1
        var line11 = [centerX, centerY, Math.min(x, line21[0]), y]
        var line12 = [centerX, centerY, Math.min(x, line22[0]), y]
        var line13 = [centerX, centerY, x, Math.min(y, line23[1])]
        var line14 = [centerX, centerY, x, Math.min(y, line24[1])]

        var line1 = isHorizontal ? (isInbound ? line13 : line14) : (isInbound ? line11 : line12)
        var line2 = isHorizontal ? (isInbound ? line23 : line24) : (isInbound ? line21 : line22)

        var dX = 0
        var dY = 0
        var index = 0
        var distance = 0

        if(isInbound) {
            index = Math.max(findIndexInbound(connection), 0)
            distance = transition.height / (Transitions.inbound.length + 1)
        } else {
            index = Math.max(findIndexOutbound(connection), 0)
            distance = transition.height / (Transitions.outbound.length + 1)
        }

        if(isHorizontal) {
            dX = (index + 1) * distance
        } else {
            dY = (index + 1) * distance
        }

        var angle = Math.atan2(x - centerX, y - centerY)
        var finalX
        var finalY

        if(isHorizontal) {
            finalX = line2[0] + dX
            finalY = line2[1]
        } else {
            finalY = line2[1] + dY
            finalX = line2[0]
        }

        return [finalX, finalY, angle]
    }

    signal clicked (variant mouse)

    property int oldX: 0
    property int oldY: 0

    id: transition
    state: 'squqozen'
    z: 2

    height: 30
    width: 6

    states: [
        State {
            name: 'squqozen'
            PropertyChanges {
                target: transition
                scale: 0.1
            }
        },
        State {
            name: 'vertical'
            PropertyChanges {
                target: transition;
                rotation: 0
            }
        },
        State {
            name: 'horizontal'
            PropertyChanges {
                target: transition;
                rotation: 90
            }
        }
    ]

    transitions: [
        Transition {
            from: "squqozen"
            to: "vertical"
            NumberAnimation { duration: 250; properties: "scale"; easing.type: Easing.InQuint }
        },
        Transition {
            from: "vertical"
            to: "horizontal"
            RotationAnimation { target: transition; duration: 100; }
        },
        Transition {
            from: "horizontal"
            to: "vertical"
            RotationAnimation { target: transition; duration: 100}
        }
    ]

    Text {
        id: label
        anchors.top: rect.bottom
        anchors.horizontalCenter: rect.horizontalCenter
        anchors.topMargin: 5
        color: focused ? 'red' : transition.color
        font.italic: true
    }

    function repaintConnections(list) {
        for(var c in list) {
            indexhandler.connection(list[c]).paint()
        }
    }

    function getPredecessors() {
        var predecessors = []
        for(var c in inbound) {
            predecessors.push(indexhandler.connection(inbound[c])
                              .getPlace()
                              .objectName)
        }
        return predecessors
    }

    function getSuccessors() {
        var successors = []
        for(var c in outbound) {
            successors.push(indexhandler.connection(outbound[c])
                            .getPlace()
                            .objectName)
        }
        return successors
    }

    function addToLabel(ch) {
        label.text = label.text + ch
    }

    function backspaceLabel() {
        label.text = label.text.substr(0, label.text.length - 1)
    }

    function addInbound(id) {
        Transitions.addInbound(id)
        height = Math.max(Transitions.inbound.length * 15, Transitions.outbound.length * 15, 30)
    }

    function addOutbound(id) {
        Transitions.addOutbound(id)
        height = Math.max(Transitions.inbound.length * 15, Transitions.outbound.length * 15, 30)
    }

    function removeInbound(id) {
        Transitions.remove(id, 'inbound')
        height = Math.max(Transitions.inbound.length * 15, Transitions.outbound.length * 15, 30)
    }

    function removeOutbound(id) {
        Transitions.remove(id, 'outbound')
        height = Math.max(Transitions.inbound.length * 15, Transitions.outbound.length * 15, 30)
    }

    function findIndexInbound(item) {
        for(var i = 0; i < Transitions.inbound.length && item; i++) {
            if(item.objectName === Transitions.inbound[i]) {
                return i;
            }
        }

        return -1;
    }

    function findIndexOutbound(item) {
        for(var j = 0; j < Transitions.outbound.length && item; j++) {
            if(item.objectName === Transitions.outbound[j]) {
                return j;
            }
        }

        return -1;
    }

    function unfocus(union) {
        focused = false
    }

    function hasInbound(id) {
        return Transitions.inbound.indexOf(id) > -1
    }

    function hasOutbound(id) {
        return Transitions.outbound.indexOf(id) > -1
    }

    function focus(union) {
        focused = true
    }

    function sortInbound() {
        Transitions.sort('inbound')
    }

    function sortOutbound() {
        Transitions.sort('outbound')
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

    onXChanged: {
        if(transition.state == 'squqozen') {
            transition.state = 'vertical'
        }

        parallelShift()
    }
    onYChanged: {
        if(transition.state == 'squqozen') {
            transition.state = 'vertical'
        }

        parallelShift()
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        border.color: focused ? 'red' : transition.color
        color: focused ? 'red' : transition.color
        antialiasing: true
    }

    MouseArea {
        id: mousearea

        anchors.fill: parent
        drag.target: transition

        onClicked: {
            if(!transition.focusGone) {
                focushandler.addFocusedClick(transition, mouse.modifiers === Qt.ShiftModifier)
            }
        }

        onReleased: {
            drag.target = transition
        }

        onPressed: {
            var withShift = (mouse.modifiers === Qt.ShiftModifier)
            if(!focused && focushandler.count() > 1 && !withShift) {
                focushandler.clearFocused()
            }

            focushandler.addFocusedPress(transition, withShift)

            if(mouse.button === Qt.LeftButton &&
                    mouse.modifiers === Qt.AltModifier) {
                var newTransition = addCenteredTransition(parent.x + mouse.x, parent.y + mouse.y)
                focushandler.addFocusedPress(newTransition, false)
                drag.target = newTransition
                transition.focusGone = true
            }
        }

        onDoubleClicked: {
            transition.state = (transition.state == 'vertical') ? 'horizontal' : 'vertical'
            resetControlPoints()
        }
    }
}
