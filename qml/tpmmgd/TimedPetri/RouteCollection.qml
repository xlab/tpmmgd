import QtQuick 2.0
import "RouteHandler.js" as Store

Item {
    id: routecollection
    property IndexHandler indexhandler
    property FocusHandler focushandler
    property var routes
    property int count
    property int routesMax: 10

    property var colors: [
        "#c0392b", "#d35400", "#f39c12",
        "#27ae60", "#3498db", "#2980b9",
        "#8e44ad", "#34495e", "#7f8c8d",
        "#bdc3c7"
    ]

    Text {
        id: label
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: label.width / 2 - 2
        color: "#34495e"
        font.italic: true
        font.pixelSize: 12
        text: "Routes:"
        rotation: -90
        visible: routecollection.count > 0
    }

    Grid {
        anchors.bottom: parent.bottom
        anchors.left: label.right
        anchors.right: parent.right
        anchors.margins: 5
        anchors.leftMargin: - label.width / 2 + 10
        spacing: 10
        columns: 1
        rows: routecollection.count
        Repeater {
            model: routecollection.routes
            delegate: route
        }
    }

    function addRoute(items) {
        if(items.length > 1 && routecollection.count < routecollection.routesMax) {
            Store.addRoute(items)
            routecollection.count = Store.routes.length
            routecollection.routes = Store.routes
            return true
        }
        return false
    }

    function removeContaining(items) {
        for(var i in items) {
            for(var j in Store.routes) {
                if(Store.check(items[i].objectName, j)) {
                    var color = routecollection.colors.splice(id, 1)
                    routecollection.colors.push(color[0])
                    Store.removeRoute(j)
                }
            }
        }
        Store.cleanRoutes()
        routecollection.count = Store.routes.length
        routecollection.routes = Store.routes
    }

    function removeRoute(id) {
        var color = routecollection.colors.splice(id, 1)
        routecollection.colors.push(color[0])
        Store.removeRoute(id)
        Store.cleanRoutes()
        routecollection.count = Store.routes.length
        routecollection.routes = Store.routes
    }

    function setRoutes(routes) {
        Store.setRoutes(routes)
        routecollection.count = Store.routes.length
        routecollection.routes = Store.routes
    }

    Component {
        id: route
        Rectangle {
            z: 10
            color: routecollection.colors[index]
            property bool fix: false
            anchors.margins: 10
            height: 30
            width: parent.width
            MouseArea {
                id: m
                hoverEnabled: true
                anchors.fill: parent
                onContainsMouseChanged: {
                    if(m.containsMouse) {
                        focushandler.clearFocused()
                        for(var name in Store.routes[index]) {
                            focushandler.addFocusedClick(indexhandler.wtf(Store.routes[index][name]), true)
                        }
                    } else {
                        parent.color = routecollection.colors[index]
                        if(!fix) focushandler.clearFocused()
                        fix = false
                    }
                }

                onPressed: parent.color = Qt.darker(routecollection.colors[index])

                onReleased: {
                    fix = true
                    parent.color = routecollection.colors[index]
                }

                onClicked: {
                    if(mouse.modifiers & Qt.ShiftModifier)
                        removeRoute(index)
                }
            }
        }
    }
}
