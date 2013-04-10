import QtQuick 2.0

Item {
    id: tp
    property Place focused

    onFocusedChanged : {
        focused.color = 'red'
    }

    Place {
        id: place1
        x: 10
        y: 50
        color: 'red'
        tokens: 3
        onClicked: {
            tp.focused = place1
        }
    }

    Place {
        id: place2
        x: 90
        y: 23
        onClicked: {
            tp.focused = place2
        }
    }

    Place {
        id: place3
        x: 546
        y: 57
        onClicked: {
            tp.focused = place3
        }
    }

    Connection {
        predecessor: place1
        successor: place2
        anchors.fill: parent
    }

}
