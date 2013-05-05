import QtQuick 2.0
import "RouteHandler.js" as Store

Item {
    id: routecollection
    property var routes: Store.routes

    Rectangle {
        anchors.fill: parent
        color: "red"
    }

    function addRoute(items) {
        Store.addRoute(items)
    }

    function removeContaining(items) {
        for(var i in items) {
            for(var j in Store.routes) {
                if(Store.check(items[i].objectName, j)) {
                    Store.removeRoute(j)
                }
            }
        }
    }


}
