import QtQuick 2.0
import "ConnectionHandler.js" as Store

Item {
    property IndexHandler indexhandler
    property CanvasHandler canvashandler
    property Item net
    id: ch

    function addConnectionOutbound(place, transition) {
        var name = Store.addConnectionOutbound(place, transition)
        var connection = Qt.createQmlObject("Connection {}", net)
        connection.objectName = name

        connection.predecessor = place
        connection.successor = transition
        connection.canvas = ch.canvashandler
        indexhandler.addConnection(connection)

        transition.sortInbound()
        return connection
    }

    function addConnectionInbound(transition, place) {
        var name = Store.addConnectionInbound(transition, place)
        var connection = Qt.createQmlObject("Connection {}", net)
        connection.objectName = name
        connection.predecessor = transition
        connection.successor = place
        connection.canvas = ch.canvashandler
        indexhandler.addConnection(connection)

        transition.sortOutbound()
        return connection
    }

    function removeConnection(predecessor, successor) {
        Store.removeConnection(predecessor, successor)
    }

    function addConnections(items) {
        for(var i = 0; i < items.length - 1; ++i) {
            var predecessor = items[i]
            var successor = items[i + 1]
            var check

            if(predecessor.isPlace && successor.isTransition) {
                check = Store.check(predecessor, successor)
                if( check === 1 ){
                    console.log("Already connected outboundely: " + predecessor.objectName + " and " + successor.objectName)
                    console.log(JSON.stringify(Store.connected))
                    return
                } else if (predecessor.outbound ) {
                    console.log(predecessor.objectName + " already has an outbound connection")
                    console.log(JSON.stringify(Store.connected))
                    return
                }

                console.log("Create outbound between " + predecessor.objectName + " and " + successor.objectName)
                addConnectionOutbound(predecessor, successor)
            } else if(predecessor.isTransition && successor.isPlace) {
                check = Store.check(successor, predecessor)
                if( check === -1 ){
                    console.log("Already connected outboundely: " + predecessor.objectName + " and " + successor.objectName)
                    console.log(JSON.stringify(Store.connected))
                    return
                } else if (successor.inbound ) {
                    console.log(successor.objectName + " already has an inbound connection")
                    console.log(JSON.stringify(Store.connected))
                    return
                }

                console.log("Create inbound between " + predecessor.objectName + " and " + successor.objectName)
                addConnectionInbound(predecessor, successor)
            } else {
                console.log("Ivalid order motherfucka!")
                return;
            }
        }
    }

    function removeConnections(items) {
        for(var i = 0; i < items.length - 1; ++i) {
            var predecessor = items[i]
            var successor = items[i + 1]

            removeConnection(predecessor, successor)
        }
    }
}
