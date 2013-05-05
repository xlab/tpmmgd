import QtQuick 2.0

Item {
    id: s
    property int x1
    property int y1
    property int x2
    property int y2

    // Selector math
    function update() {
        width = Math.abs(x2 - x1)
        height = Math.abs(y2 - y1)
        x = x1 < x2 ? x1 : x2
        y = y1 < y2 ? y1 : y2
    }

    function containsPoint(x, y) {
        if ((x > s.x &&  y > s.y) && (x < (s.x + width) &&  y < (s.y + height))) {
            return true
        } else {
            return false
        }
    }

    DashedRect {
        anchors.fill: parent
        color: "#bdc3c7"
    }
}
