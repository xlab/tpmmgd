import QtQuick 2.0

Item {
    id: savebutton
    property var onClicked
    property string defcolor: "#27ae60"
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
        onReleased: background.color = defcolor
        onClicked: savebutton.onClicked()
    }
}
