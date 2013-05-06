import QtQuick 2.0

Item {
    id: transitionbutton
    width: 20
    state: "steady"
    property string defcolor: '#1abc9c'
    property int activeHeight
    property TimedPetri timedpetri

    Rectangle {
        anchors.fill: parent
        color: transitionbutton.defcolor
        MouseArea {
            anchors.fill: parent
            onPressed: {
                transitionbutton.state = "active"
                parent.color = Qt.darker(transitionbutton.defcolor)
                timedpetri.focushandler.clearFocused()
                var transition = timedpetri.addCenteredTransition(transitionbutton.x + mouse.x,
                                                timedpetri.height + transitionbutton.y + mouse.y)
                drag.target = transition
                timedpetri.focushandler.addFocusedPress(transition, false)
            }

            onReleased: {
                transitionbutton.state = "steady"
                parent.color = transitionbutton.defcolor
            }
        }
    }

    states: [
        State {
            name: "steady"
            PropertyChanges {
                target: transitionbutton
                height: 20
            }
        },
        State {
            name: "active"
            PropertyChanges {
                target: transitionbutton
                height: activeHeight
            }
        }
    ]

    transitions: [
        Transition {
            from: "steady"; to: "active"
            NumberAnimation { properties: "height"; easing.type: Easing.InQuint}
        },
        Transition {
            from: "active"; to: "steady"
            NumberAnimation { properties: "height"; easing.type: Easing.OutElastic}
        }
    ]
}
