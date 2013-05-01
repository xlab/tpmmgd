import QtQuick 2.0

Item {
    id: control
    property string type
    property int centerX: x + width / 2
    property int centerY: y + height / 2

    width: 6
    height: 6

    Rectangle {
        color: type === 'inbound' ? 'red' : 'blue'
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            drag.target: control
        }
    }
}
