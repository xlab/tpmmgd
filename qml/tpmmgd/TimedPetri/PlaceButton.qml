import QtQuick 2.0

Item {
    id: placebutton
    width: 20
    state: "steady"
    property string defcolor: '#e74c3c'
    property int activeHeight
    property TimedPetri timedpetri

    Rectangle {
        anchors.fill: parent
        color: placebutton.defcolor
        MouseArea {
            anchors.fill: parent
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
                placebutton.state = "steady"
                parent.color = placebutton.defcolor
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
