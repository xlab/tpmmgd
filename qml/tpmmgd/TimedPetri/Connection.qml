import QtQuick 2.0

Item {
    id: connection
    property variant predecessor: Place {}
    property variant successor: TransitionBar {}

    property int startX: {predecessor.borderPoint(pointControl.x, pointControl.y, connection)[0]}
    property int startY: {predecessor.borderPoint(pointControl.x, pointControl.y, connection)[1]}
    property int endX: {successor.borderPoint(pointControl.x, pointControl.y, connection)[0]}
    property int endY: {successor.borderPoint(pointControl.x, pointControl.y, connection)[1]}
    property var inboundA: {successor.borderPoint(pointControl.x, pointControl.y, connection)[2]}

    property bool isConnection: true
    property bool selected: {predecessor.focused && successor.focused}
    z: 1
    anchors.fill: parent

    onSelectedChanged: canvas.requestPaint()

    onPredecessorChanged: {
        predecessor.onCenterXChanged.connect(
                    canvas.requestPaint)
        predecessor.onCenterYChanged.connect(
                    canvas.requestPaint)

        predecessor.outboundCurvecontrol = pointControl
    }

    onSuccessorChanged: {
        successor.onCenterXChanged.connect(
                    canvas.requestPaint)
        successor.onCenterYChanged.connect(
                    canvas.requestPaint)

        successor.inboundCurvecontrol = pointControl
    }

    CurveControl {
        property var owner: {
            return successor.isTransition ? successor : predecessor
        }

        property var notOwner: {
            return successor.isTransition ? predecessor : successor
        }

        x: {
            owner.borderPoint(notOwner.centerX,
                                  notOwner.centerY, connection)[0] - 40
        }

        y: {
            owner.borderPoint(notOwner.centerX,
                                  notOwner.centerY, connection)[1]
        }

        id: pointControl
        visible: owner.focused
        onXChanged: canvas.requestPaint()
        onYChanged: canvas.requestPaint()
        onStateChanged: canvas.requestPaint()
    }

    function sgn(n) {
        return n?n<0?-1:1:0
    }

    function rotatePoint(pX, pY, oX, oY, angle) {
        return [oX + (pX - oX) * Math.cos(angle) - (pY - oY) * Math.sin(angle),
                oY + (pX - oX) * Math.sin(angle) + (pY - oY) * Math.cos(angle)]
    }

    function getPlace(){
        return predecessor.isPlace ? predecessor : successor
    }

    function getTransition(){
        return predecessor.isTransition ? predecessor : successor
    }

    function requestPaint() {
        console.log('Requested painted! LOL')
        //canvas.requestPaint()
        connection.update()
    }

    Canvas {
        id: canvas
        antialiasing: true
        anchors.fill: parent
        contextType: "2d"

        onPaint: {
            var c = context
            c.reset()
            c.clearRect(0,0,canvas.width, canvas.height)
            c.strokeStyle = selected ? '#ff00ff' : '#000000'
            c.lineWidth = '2'
            c.path = curve
            c.stroke()

            var p1X = endX
            var p1Y = endY
            var p2X = p1X - 5
            var p2Y = p1Y + 5
            var p3X = p1X + 5
            var p3Y = p1Y + 5

            var p1 = rotatePoint(p1X, p1Y, p1X, p1Y, -connection.inboundA)
            var p2 = rotatePoint(p2X, p2Y, p1X, p1Y, -connection.inboundA)
            var p3 = rotatePoint(p3X, p3Y, p1X, p1Y, -connection.inboundA)

            c.beginPath()
            c.moveTo(p1[0], p1[1])
            c.lineTo(p2[0], p2[1])
            c.lineTo(p3[0], p3[1])
            c.lineTo(p1[0], p1[1])
            c.closePath()
            c.fillStyle = selected ? '#ff00ff' : '#000000'
            c.fill()

            c.stroke()

            predecessor.update()
            successor.update()
        }

        Path {
            id: curve
            startX: connection.startX
            startY: connection.startY

            PathQuad {
                x: connection.endX
                y: connection.endY
                controlX: pointControl.x; controlY: pointControl.y;
            }
        }
    }
}
