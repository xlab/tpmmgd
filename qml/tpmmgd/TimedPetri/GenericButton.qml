import QtQuick 2.0

Item {
    id: genericbutton
    property var onClicked
    property string defcolor: "#9b59b6"
    property HelperLabel helperlabel
    property int useCount: 0
    property bool used: useCount > 2
    width: 20
    height: 20

    Rectangle {
        id: background
        color: defcolor
        anchors.fill: parent

        Text {
            anchors.centerIn: parent
            color: "#ecf0f1"
            text: "M"
            font.bold: true
        }
    }

    MouseArea {
        id: m
        anchors.fill: parent
        onPressed: background.color = Qt.darker(defcolor)
        onClicked: genericbutton.onClicked()
        onReleased: {
            background.color = defcolor
            genericbutton.useCount += 1
        }

        hoverEnabled: !genericbutton.used
        onContainsMouseChanged: {
            if(containsMouse && !genericbutton.used) {
                helperlabel.text = "Handle selected items as a consistent model in the MathView below."
                helperlabel.visible = true
            } else {
                helperlabel.text = ""
                helperlabel.visible = false
            }
        }
    }
}
