import QtQuick 2.0

Item {
    id: control
    property string type

    Rectangle {
        width: 6
        height: 6
        color: type === 'inbound' ? 'red' : 'blue'

        MouseArea {
            anchors.fill: parent
            drag.target: control
        }
    }
}
