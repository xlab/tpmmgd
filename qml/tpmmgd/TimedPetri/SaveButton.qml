import QtQuick 2.0

Item {
    id: savebutton
    property var onClicked
    property string defcolor: "#27ae60"
    property HelperLabel helperlabel
    property int useCount: 0
    property bool used: useCount > 0
    width: 20
    height: 20

    Rectangle {
        id: background
        color: defcolor
        anchors.fill: parent
    }

    MouseArea {
        id: m
        anchors.fill: parent
        onPressed: background.color = Qt.darker(defcolor)
        onClicked: savebutton.onClicked()
        onReleased: {
            background.color = defcolor
            savebutton.useCount += 1
        }

        hoverEnabled: !savebutton.used
        onContainsMouseChanged: {
            if(containsMouse && !savebutton.used) {
                helperlabel.text = "This is for :writing to a file"
                helperlabel.visible = true
            } else {
                helperlabel.text = ""
                helperlabel.visible = false
            }
        }
    }
}
