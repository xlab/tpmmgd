import QtQuick 2.0
import QtWebKit 3.0

Rectangle {
    property MathView mathview: mathview
    property CodeView codeview: codeview

    id: editor
    width: 200
    height: 200
    onWidthChanged: {
        separator.x = editor.width * 1/2
    }

    MathView {
        id: mathview
        height: parent.height
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            right: separator.left
        }
    }

    Rectangle {
        id: separator
        color: "#ecf0f1"
        border.color: "#95a5a6"
        height: parent.height + 2
        width: 11
        anchors.verticalCenter: parent.verticalCenter
        x: editor.width * 1/2
        property bool moved: false

        onXChanged: {
            if(!separator.moved && !separator.x) {
                separator.x = editor.width * 1/2
            } else if(!separator.moved && separator.x > 0) {
                separator.moved = true
            } else {
                separator.x = Math.min(Math.max(separator.x, 98), editor.width - 98)
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: drag.target = separator
            onReleased: drag.target = undefined
        }


        Grid {
            width: 3
            height: 10
            spacing: 3
            columns: 1
            anchors.centerIn: parent

            Repeater {
                model: 3
                Rectangle {
                    width: 3
                    height: 3
                    color: "#95a5a6"
                }
            }
        }
    }

    CodeView {
        id: codeview
        height: parent.height
        anchors {
            left: separator.right
            verticalCenter: parent.verticalCenter
            right: parent.right
        }
    }
}
