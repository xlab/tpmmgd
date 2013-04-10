import QtQuick 2.0

Item
{
    property int tokens: 0
    property int maxTokens: 16
    property string color: 'black'
    property int centerX: x + width / 2
    property int centerY: y + height / 2
    signal clicked

    id: place
    width: 50
    height: 50
    z: 2

    Rectangle {
        id: rect
        anchors.fill: parent
        radius: width * 0.5
        border.color: place.color
        color: 'white'
        antialiasing: true

        Grid {
            anchors.centerIn: parent
            anchors.margins: 4
            spacing: 3
            Repeater {
                model: place.tokens
                Token {}
            }
        }
    }

    Drag.active: dragArea.drag.active

    MouseArea {
        id: dragArea
        function toggleTokens (m) {
            if(m.modifiers === Qt.NoModifier) {
                if(place.tokens < place.maxTokens) ++place.tokens
            } else if(m.modifiers === Qt.ShiftModifier) {
                if(place.tokens > 0) --place.tokens
            }
        }

        anchors.fill: parent
        drag.target: place
        cursorShape: "DragMoveCursor"
        onDoubleClicked: toggleTokens(mouse)
        onClicked: place.clicked(mouse)
    }
}
