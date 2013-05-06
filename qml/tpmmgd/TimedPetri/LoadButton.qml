import QtQuick 2.0

Item {
    id: loadbutton
    property var onClicked
    property string defcolor: "#c0392b"
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
        onClicked: loadbutton.onClicked()
    }
}
