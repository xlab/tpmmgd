import QtQuick 2.0

Item {
    id: screenshotbutton
    property var onClicked
    property string defcolor: "#2980b9"
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
            text: "S"
        }
    }

    MouseArea {
        id: m
        anchors.fill: parent
        onPressed: background.color = Qt.darker(defcolor)
        onClicked: screenshotbutton.onClicked()
        onReleased: {
            background.color = defcolor
            screenshotbutton.useCount += 1
        }

        hoverEnabled: !screenshotbutton.used
        onContainsMouseChanged: {
            if(containsMouse && !screenshotbutton.used) {
                helperlabel.text = "This is for taking screenshots"
                helperlabel.visible = true
            } else {
                helperlabel.text = ""
                helperlabel.visible = false
            }
        }
    }
}
