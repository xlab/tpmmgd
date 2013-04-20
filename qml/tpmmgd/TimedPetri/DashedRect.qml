import QtQuick 2.0


Item {
    id: dr
    property string color: "black"
    property int dashLentgh: 3
    property int dashThickness: 1
    signal onResize

    PathView {
        anchors.fill: parent
        model: dr.height / (dr.dashLentgh * 2)
        delegate: Rectangle { width: dr.dashThickness; height: dr.dashLentgh; color: dr.color}
        path: left
    }

    PathView {
        anchors.fill: parent
        model: dr.width / (dr.dashLentgh * 2)
        delegate: Rectangle { width: dr.dashLentgh; height: dr.dashThickness; color: dr.color}
        path: top
    }

    PathView {
        anchors.fill: parent
        model: dr.height / (dr.dashLentgh * 2)
        delegate: Rectangle { width: dr.dashThickness; height: dr.dashLentgh; color: dr.color}
        path: right
    }

    PathView {
        anchors.fill: parent
        model: dr.width / (dr.dashLentgh * 2)
        delegate: Rectangle { width: dr.dashLentgh; height: dr.dashThickness; color: dr.color}
        path: bottom
    }

    Path {
        id: left
        PathLine { x: 0; y: height }
    }
    Path {
        id: top
        startX: dr.dashLentgh; startY: -dr.dashLentgh;
        PathLine { x: width + dr.dashLentgh; y: -dr.dashLentgh }
    }
    Path {
        id: right
        startX: width; startY: 0
        PathLine { x: width; y: height }
    }
    Path {
        id: bottom
        startX: dr.dashLentgh; startY: height - dr.dashLentgh;
        PathLine { x: width + dr.dashLentgh; y: height - dr.dashLentgh}
    }
}
