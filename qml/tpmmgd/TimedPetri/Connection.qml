import QtQuick 2.0

Item {
    id: connection
    property variant predecessor: Place {}
    property variant successor: TransitionBar {}

    property int startX: {predecessor.borderPoint(pointControl.centerX, pointControl.centerY, connection)[0]}
    property int startY: {predecessor.borderPoint(pointControl.centerX, pointControl.centerY, connection)[1]}
    property int endX: {successor.borderPoint(pointControl.centerX, pointControl.centerY, connection)[0]}
    property int endY: {successor.borderPoint(pointControl.centerX, pointControl.centerY, connection)[1]}
    property var inboundA: {successor.borderPoint(pointControl.centerX, pointControl.centerY, connection)[2]}
    property bool isTransitionInbound: (successor && successor.isTransition) ? true : false

    property bool isConnection: true
    property bool selected: {predecessor.focused && successor.focused}
    property CanvasHandler canvas: CanvasHandler {}

    z: 1

    onSelectedChanged: canvas.repaint()
    onStateChanged: canvas.repaint()

    onPredecessorChanged: {
        if(predecessor.isPlace) {
            predecessor.onCenterXChanged.connect(paint)
            predecessor.onCenterYChanged.connect(paint)
        }
    }

    onSuccessorChanged: {
        if(successor.isPlace) {
            successor.onCenterXChanged.connect(paint)
            successor.onCenterYChanged.connect(paint)
        }
    }

    CurveControl {
        property var owner: {
            return successor.isTransition ? successor : predecessor
        }

        property var notOwner: {
            return successor.isTransition ? predecessor : successor
        }

        x: {
            if(owner.isHorizontal) {
                owner.borderPoint(notOwner.centerX,
                                  notOwner.centerY, connection)[0] - pointControl.width / 2
            } else {
                owner.borderPoint(notOwner.centerX,
                                  notOwner.centerY, connection)[0] +
                        + (connection.isTransitionInbound ? -1 : 1) * 40 - pointControl.width / 2
            }
        }

        y: {
            if(owner.isHorizontal) {
                owner.borderPoint(notOwner.centerX,
                                      notOwner.centerY, connection)[1] +
                        + (connection.isTransitionInbound ? -1 : 1)*30 - pointControl.height / 2
            } else {
                owner.borderPoint(notOwner.centerX,
                                      notOwner.centerY, connection)[1] - pointControl.height / 2
            }
        }

        id: pointControl
        visible: owner.focused
        onXChanged: canvas.repaint()
        onYChanged: canvas.repaint()
    }

    function paint() {
        if(canvas)
        canvas.repaint()
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

    function getGraphics() {
        var p1X = endX
        var p1Y = endY
        var p2X = p1X - 3
        var p2Y = p1Y + 5
        var p3X = p1X
        var p3Y = p1Y + (5 * 2/3)
        var p4X = p1X + 3
        var p4Y = p1Y + 5

        var p1 = rotatePoint(p1X, p1Y, p1X, p1Y, -connection.inboundA)
        var p2 = rotatePoint(p2X, p2Y, p1X, p1Y, -connection.inboundA)
        var p3 = rotatePoint(p3X, p3Y, p1X, p1Y, -connection.inboundA)
        var p4 = rotatePoint(p4X, p4Y, p1X, p1Y, -connection.inboundA)

        return [selected, curve, p1, p2, p3, p4]
    }

    Path {
        id: curve
        startX: connection.startX
        startY: connection.startY

        PathQuad {
            x: connection.endX
            y: connection.endY
            controlX: pointControl.centerX; controlY: pointControl.centerY;
        }
    }
}
