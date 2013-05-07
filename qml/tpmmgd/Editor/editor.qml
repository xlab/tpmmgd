import QtQuick 2.0
import QtWebKit 3.0

Rectangle {
    id: editor
    width: 200
    height: 200
    onWidthChanged: {
        separator.x = editor.width * 1/2
    }

    WebView {
        id: wv1
        height: parent.height - 20
        url: 'latex.html'
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
            right: separator.left
            rightMargin: 10
        }
    }

    Rectangle {
        id: separator
        color: "#95a5a6"
        height: parent.height
        width: 4

        anchors {
            verticalCenter: parent.verticalCenter
        }

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
    }

    WebView {
        id: wv2
        height: parent.height - 20
        anchors {
            left: separator.right
            leftMargin: 10
            right: parent.right
            rightMargin: 10
            verticalCenter: parent.verticalCenter
        }
    }
}
