import QtQuick 2.0
import 'TransitionStore.js' as Transitions

Item
{
    property int tokens: 0
    property int maxTokens: 16
    property bool isTransition: true
    property string color: 'black'
    property int centerX: x + width / 2
    property int centerY: y + height / 2
    property bool focused: false
    property bool beingDragged: mousearea.drag.active
    property FocusHandler focushandler
    property IndexHandler indexhandler
    property CurveControl inboundCurvecontrol
    property CurveControl outboundCurvecontrol

    property var collisionPoints: {
        var cp1 = []; cp1[0] = x; cp1[1] = y
        var cp2 = []; cp2[0] = x + width; cp2[1] = y
        var cp3 = []; cp3[0] = x; cp3[1] = y + height
        var cp4 = []; cp4[0] = x + width; cp4[1] = y + height
        return [cp1, cp2, cp3, cp4]
    }

    function sgn(n) {
        return n?n<0?-1:1:0
    }

    function borderPoint(x, y, connection) {
        var offset = 3

        // line 2 - variant vetical inbound
        var line21 = [
            transition.x - offset, // x3 line2[0]
            transition.y, // y3 line2[1]
            transition.x - offset, // x4 line2[2]
            transition.y + height // y4 line2[3]
        ]

        // line 3 - variant vetical outbound
        var line22 = [
            transition.x + width + offset, // x3 line2[0]
            transition.y, // y3 line2[1]
            transition.x + width + offset, // x4 line2[2]
            transition.y + height, // y4 line2[3]
        ]

        // line 1
        var line11 = [centerX, centerY, Math.min(x, line21[0]), y]
        var line12 = [centerX, centerY, Math.min(x, line22[0]), y]

        var line1 = line11
        var line2 = line21

        /*
        // line 2 - variant horizontal inbound
        var x3 = transition.x - offset
        var y3 = transition.y - offset
        var x4 = transition.x - offset
        var y4 = transition.y + height + offset

        // line 3 - variant horizontal outbound
        var x3 = transition.x + width + offset
        var y3 = transition.y - offset
        var x4 = transition.x + width + offset
        var y4 = transition.y + height + offset
        */

        var dY = 0
        var index = Math.max(findIndex(connection), 0)
        var distance = transition.height / (Transitions.outbound.length + 1)
        dY = (index + 1) * distance

        var A1 = (line2[2] - line2[0])*(line1[1] - line2[1])
        var A2 = (line2[3] - line2[1])*(line1[2] - line1[0])
        var A3 = (line2[3] - line2[1])*(line1[0] - line2[0])
        var A4 = (line2[2] - line2[0])*(line1[3] - line1[1])

        var uA = (A1 - A3) / (A2 - A4)

        var angle = Math.atan2(x - centerX, y - centerY)

        var resultX = line1[0] + uA*(line1[2] - line1[0])
        var resultY = line1[1] + uA*(line1[3] - line1[1])
        var finalY = line2[1] + dY
        return [resultX, finalY, angle]
    }

    signal clicked (variant mouse)

    property int oldX: 0
    property int oldY: 0

    id: transition
    state: 'squqozen'
    z: 2

    width: 4
    height: 30

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

    function addInbound(id) {
        Transitions.addInbound(id)
        console.log("inbound: " + JSON.stringify(Transitions.inbound))
        console.log("outbound: " + JSON.stringify(Transitions.outbound))
        height = Math.max(Transitions.inbound.length * 15, Transitions.outbound.length * 15, 30)
    }

    function addOutbound(id) {
        Transitions.addOutbound(id)
        console.log("inbound: " + JSON.stringify(Transitions.inbound))
        console.log("outbound: " + JSON.stringify(Transitions.outbound))
        height = Math.max(Transitions.inbound.length * 15, Transitions.outbound.length * 15, 30)
    }

    function removeInbound(id) {
        Transitions.remove(id, 'inbound')
        console.log("inbound: " + JSON.stringify(Transitions.inbound))
        console.log("outbound: " + JSON.stringify(Transitions.outbound))
        height = Math.max(Transitions.inbound.length * 15, Transitions.outbound.length * 15, 30)
    }

    function removeOutbound(id) {
        Transitions.remove(id, 'outbound')
        console.log("inbound: " + JSON.stringify(Transitions.inbound))
        console.log("outbound: " + JSON.stringify(Transitions.outbound))
        height = Math.max(Transitions.inbound.length * 15, Transitions.outbound.length * 15, 30)
    }

    function findIndex(item) {
        for(var i = 0; i < Transitions.inbound.length && item; i++) {
            if(item.objectName === Transitions.inbound[i]) {
                return i;
            }
        }

        for(var j = 0; i < Transitions.outbound.length && item; j++) {
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

    function inbound() {
        return Transitions.inbound
    }

    function outbound() {
        return Transitions.outbound
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
        //cursorShape: "DragMoveCursor"
        //onDoubleClicked: toggleTokens(mouse)
        onClicked: {
            focushandler.addFocusedClick(transition,
                                mouse.modifiers === Qt.ShiftModifier)
        }

        onPressed: {
            var withShift = (mouse.modifiers === Qt.ShiftModifier)
            if(!focused && focushandler.count() > 1 && !withShift) {
                focushandler.clearFocused()
            }

            focushandler.addFocusedPress(transition, withShift)
        }

        onDoubleClicked: {
            transition.state = (transition.state == 'vertical') ? 'horizontal' : 'vertical'
        }
    }
}
