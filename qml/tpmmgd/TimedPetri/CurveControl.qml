import QtQuick 2.0

Item {
    id: control
    property int centerX: x + width / 2
    property int centerY: y + height / 2

    width: 6
    height: 6

    Rectangle {
        color: '#f1c40f'
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            drag.target: control
            onPressed: {
                parent.forceActiveFocus()
            }
        }
    }
}
