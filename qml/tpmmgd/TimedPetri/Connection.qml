import QtQuick 2.0

Item {
    property Place predecessor
    property Place successor
    z: 1

    onPredecessorChanged: {
        predecessor.onCenterXChanged.connect(
                    canvas.requestPaint)
        predecessor.onCenterYChanged.connect(
                    canvas.requestPaint)
    }

    onSuccessorChanged: {
        successor.onCenterXChanged.connect(
                    canvas.requestPaint)
        successor.onCenterYChanged.connect(
                    canvas.requestPaint)
    }

    Rectangle {
        id: control1
        width: 6
        height: 6
        x: predecessor.x + 50
        y: predecessor.y + 50
        radius: width * 0.5
        color: 'red'

        onXChanged: canvas.requestPaint
        onYChanged: canvas.requestPaint

        Drag.active: ma1.drag.active

        MouseArea {
            anchors.fill: parent
            id: ma1
            drag.target: control1
        }
    }

    Rectangle {
        id: control2
        width: 6
        height: 6
        x: successor.x + 50
        y: successor.y + 50
        radius: width * 0.5
        color: 'red'

        Drag.active: ma2.drag.active

        MouseArea {
            anchors.fill: parent
            id: ma2
            drag.target: control2
        }
    }

    Canvas {
        id: canvas
        antialiasing: true
        anchors.fill: parent
        contextType: "2d"
        onPaint: {
            var c = context
            c.clearRect(0,0,canvas.width, canvas.height)
            c.strokeStyle = '#ff00ff'
            c.lineWidth = '2'
            c.path = curve;
            c.stroke();

            predecessor.update()
            successor.update()
        }

        Path {
            id: curve
            startX: predecessor.centerX;
            startY: predecessor.centerY;

            PathCubic {
                x: successor.centerX
                y: successor.centerY
                control1X: control1.x; control1Y: control1.y;
                control2X: control2.x; control2Y: control2.y;
            }
        }
    }
}
