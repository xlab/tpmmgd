import QtQuick 2.0

Item {
    id: transitionbutton
    width: 20
    state: "steady"
    property string defcolor: '#2ecc71'
    property int activeHeight
    property TimedPetri timedpetri
    property HelperLabel helperlabel
    property int useCount: 0
    property bool used: useCount > 1

    Rectangle {
        anchors.fill: parent
        color: transitionbutton.defcolor

        Rectangle {
            anchors.centerIn: parent
            antialiasing: true
            color: '#ecf0f1'
            width: 4
            height: 12
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: !transitionbutton.used
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
                parent.color = transitionbutton.defcolor
                transitionbutton.state = "steady"
                transitionbutton.useCount += 1
            }

            onContainsMouseChanged: {
                if(containsMouse && !transitionbutton.used) {
                    helperlabel.text = "Drag this to create a Transition."
                    helperlabel.visible = true
                } else {
                    helperlabel.text = ""
                    helperlabel.visible = false
                }
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
