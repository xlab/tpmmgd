import QtQuick 2.0

Item {
    id: placebutton
    width: 20
    state: "steady"
    property string defcolor: '#e74c3c'
    property int activeHeight
    property TimedPetri timedpetri
    property HelperLabel helperlabel
    property int useCount: 0
    property bool used: useCount > 1

    Rectangle {
        anchors.fill: parent
        color: placebutton.defcolor

        Rectangle {
            anchors.centerIn: parent
            color: "#ecf0f1"
            radius: width * 0.5
            width: 8
            height: 8
            antialiasing: true
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: !placebutton.used
            onPressed: {
                placebutton.state = "active"
                parent.color = Qt.darker(placebutton.defcolor)
                timedpetri.focushandler.clearFocused()
                var place = timedpetri.addCenteredPlace(placebutton.x + mouse.x,
                                                        timedpetri.height + placebutton.y + mouse.y)
                drag.target = place
                timedpetri.focushandler.addFocusedPress(place, false)
            }

            onReleased: {
                parent.color = placebutton.defcolor
                placebutton.state = "steady"
                placebutton.useCount += 1
            }

            onContainsMouseChanged: {
                if(containsMouse && !placebutton.used) {
                    helperlabel.text = "Drag this to create a Place."
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
                target: placebutton
                height: 20
            }
        },
        State {
            name: "active"
            PropertyChanges {
                target: placebutton
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
