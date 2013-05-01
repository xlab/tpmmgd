import QtQuick 2.0

Item {
    id: handler
    property IndexHandler indexhandler
    onWidthChanged: repaint()
    onHeightChanged: repaint()

    function repaint() {
        canvas.markDirty()
        canvas.requestPaint()
    }

    function clear(context) {
        context.reset()
        context.clearRect(0, 0, width, height)
    }

    function paintConnection(context, selected, path, p1, p2, p3, p4) {
        var c = context

        c.strokeStyle = selected ? '#ff00ff' : '#000000'
        c.lineWidth = '2'
        c.path = path
        c.stroke()

        c.beginPath()
        c.moveTo(p1[0], p1[1])
        c.lineTo(p2[0], p2[1])
        c.lineTo(p3[0], p3[1])
        c.lineTo(p4[0], p4[1])
        c.lineTo(p1[0], p1[1])
        c.closePath()
        c.fillStyle = selected ? '#ff00ff' : '#000000'
        c.fill()
        c.stroke()
    }

    Canvas {
        id: canvas
        antialiasing: true
        contextType: "2d"
        anchors.fill: parent
        tileSize: "16x16"

        onPaint: {
            var c = canvas.getContext("2d")
            handler.clear(c)

            for(var cname in indexhandler.connections) {
                var g = indexhandler.connection(cname).getGraphics()
                // [selected, curve, p1, p2, p3, p4]

                handler.paintConnection(c, g[0], g[1], g[2], g[3], g[4], g[5])
            }
        }
    }
}
