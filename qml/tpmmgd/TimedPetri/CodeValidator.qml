import QtQuick 2.0

Rectangle {
    id: validator
    width: 80
    height: 20
    color: "#ecf0f1"
    property bool valid: true
    property HelperLabel helperlabel

    Text {
        id: label
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        state: validator.valid ? "valid" : "invalid"
        font.pointSize: 12

        states: [
            State {
                name: "valid"
                PropertyChanges {
                    target: label
                    text: "Code is valid"
                    color: "darkgreen"
                }
            },
            State {
                name: "invalid"
                PropertyChanges {
                    target: label
                    text: "Code is invalid"
                    color: "darkred"
                }
            }
        ]
    }

    MouseArea {
        id: m
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: {
            if(containsMouse) {

                if(validator.valid) {
                    helperlabel.text = "Your JS code does not contain any syntax errors. Your math still could have some errors."
                } else {
                    helperlabel.text = "Your JS code contains more than zero syntax errors. Please, read the manual."
                }

                helperlabel.visible = true
            } else {
                helperlabel.text = ""
                helperlabel.visible = false
            }
        }
    }
}
