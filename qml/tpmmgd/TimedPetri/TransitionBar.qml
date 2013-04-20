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

    function borderPoint(x, y) {
        var angle = Math.atan2(x - centerX, y - centerY)

        var dX = width / 2
        var dY = width / 2 + Math.tan(angle / 2)

        return [centerX + dX, centerY + dY, angle]
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
