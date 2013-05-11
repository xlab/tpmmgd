import QtQuick 2.0

Item {
    id: loadbutton
    property var onClicked
    property string defcolor: "#2c3e50"
    property HelperLabel helperlabel
    property int useCount: 0
    property bool used: useCount > 0
    width: 20
    height: 20

    Rectangle {
        id: background
        color: defcolor
        anchors.fill: parent

        Text {
            anchors.centerIn: parent
            color: "#ecf0f1"
            text: "R"
            font.bold: true
        }
    }

    MouseArea {
        id: m
        anchors.fill: parent
        onPressed: background.color = Qt.darker(defcolor)
        onClicked: loadbutton.onClicked()
        onReleased: {
            background.color = defcolor
            loadbutton.useCount += 1
        }

        hoverEnabled: !loadbutton.used
        onContainsMouseChanged: {
            if(containsMouse && !loadbutton.used) {
                helperlabel.text = "This is for reading from a file"
                helperlabel.visible = true
            } else {
                helperlabel.text = ""
                helperlabel.visible = false
            }
        }
    }
}
