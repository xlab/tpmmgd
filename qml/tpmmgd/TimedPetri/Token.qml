import QtQuick 2.0

Item {
    z: 3
    width: 6
    height: 14
    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        color: 'black'
        width: 6
        height: 6
        radius: width * 0.5
        z: 3
    }
}
