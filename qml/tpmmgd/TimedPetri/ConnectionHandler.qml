import QtQuick 2.0
import "ConnectionHandler.js" as Store

Item {
    property IndexHandler indexhandler
    property CanvasHandler canvashandler
    property Item net
    id: ch

    function addConnectionOutbound(places, transition) {
        for(var id in places) {
            var place = places[id]
            if(place.outbound || Store.check(place, transition)) return
            var name = Store.addConnectionOutbound(place, transition)
            var connection = Qt.createQmlObject("Connection {}", net)
            connection.objectName = name

            connection.predecessor = place
            connection.successor = transition
            connection.canvas = ch.canvashandler
            indexhandler.addConnection(connection)
        }

        transition.sortInbound()
    }

    function addConnectionInbound(transition, places) {
        for(var id in places) {
            var place = places[id]
            if(place.inbound || Store.check(place, transition)) return
            var name = Store.addConnectionInbound(transition, place)
            var connection = Qt.createQmlObject("Connection {}", net)
            connection.objectName = name

            connection.predecessor = transition
            connection.successor = place
            connection.canvas = ch.canvashandler
            indexhandler.addConnection(connection)
        }

        transition.sortOutbound()
    }

    function removeConnection(predecessor, successor) {
        Store.removeConnection(predecessor, successor)
    }

    function addConnections(items) {
        var groups = []
        var group
        var border = 0
        for(var i = 0; i < items.length - 1; ++i) {
            var current = items[i]
            var next = items[i + 1]

            if(current.isTransition && next.isTransition) {
                group = items.slice(border, i + 1)
                groups.push(group)
                border = i + 1
            }
        }

        group = items.slice(border, items.length + 1)
        groups.push(group)

        // At this point we have (0 < N <= items.length) groups
        console.assert(0 < groups.length && groups.length <= items.length, "Groups count mismatch!")

        for(var id in groups) {
            group = groups[id]

            if(group.length < 2 && group.pop().isTransition) {
                // nothing to do here
                // case 4. t
                continue
            }

            // containers
            var place
            var transition
            var places
            var placery // if we now collecting places

            for(var j = 0; j < group.length; j++) {
                places = []
                placery = group[j].isPlace

                if(placery) {
                    while(j < group.length && group[j].isPlace) {
                        places.push(group[j++])
                    }

                    // end placery
                    // cases: [ppp_, tppp_, ppp_t, tppp_t]
                    var not_end = (j < group.length)
                    if(transition) {
                        // tppp_, tppp_t
                        if(not_end) {
                            // tppp_t
                            addConnectionInbound(transition, places)
                            transition = group[j]
                            addConnectionOutbound(places, transition)
                        } else {
                            // tppp_
                            addConnectionInbound(transition, places)
                        }
                    } else {
                        // ppp_, ppp_t
                        if(not_end) {
                            // ppp_t
                            transition = group[j]
                            addConnectionOutbound(places, transition)
                        } else {
                            // ppp_
                            // dothing to do here
                        }
                    }
                } else {
                    transition = group[j]
                }
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
