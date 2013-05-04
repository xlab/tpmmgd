import QtQuick 2.0
import "ConnectionHandler.js" as Store

Item {
    property IndexHandler indexhandler
    property CanvasHandler canvashandler
    property Item net
    property var connected: Store.connected
    id: ch

    function addConnectionInbound(places, transition) {
        var connections = []
        for(var id in places) {
            var place = places[id]
            if(place.outbound || Store.check(place, transition) > 0) return
            var name = Store.addConnectionInbound(place, transition)
            var connection = Qt.createQmlObject("Connection {}", net)
            connection.objectName = name
            connection.predecessor = place
            connection.successor = transition
            connection.canvas = ch.canvashandler
            connections.push(connection)
            indexhandler.addConnection(connection)
        }
        transition.sortInbound()
        for(var c in connections) {
            connections[c].fixCtrl()
        }
        canvashandler.repaint()
    }

    function addConnectionOutbound(transition, places) {
        var connections = []
        for(var id in places) {
            var place = places[id]
            if(place.inbound || Store.check(place, transition) < 0) return
            var name = Store.addConnectionOutbound(transition, place)
            var connection = Qt.createQmlObject("Connection {}", net)
            connection.objectName = name

            connection.predecessor = transition
            connection.successor = place
            connection.canvas = ch.canvashandler
            connections.push(connection)
            indexhandler.addConnection(connection)
        }
        transition.sortOutbound()
        for(var c in connections) {
            connections[c].fixCtrl()
        }
        canvashandler.repaint()
    }

    function setConnections(items, state) {
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
                            if(state) {
                                addConnectionOutbound(transition, places)
                                transition = group[j]
                                addConnectionInbound(places, transition)
                            } else {
                                removeConnection(places, transition)
                                transition = group[j]
                                removeConnection(places, transition)
                            }
                        } else {
                            // tppp_
                            if(state) {
                                addConnectionOutbound(transition, places)
                            } else {
                                removeConnection(places, transition)
                            }
                        }
                    } else {
                        // ppp_, ppp_t
                        if(not_end) {
                            // ppp_t
                            transition = group[j]
                            if(state) {
                                addConnectionInbound(places, transition)
                            } else {
                                removeConnection(places, transition)
                            }
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

    function removeConnection(places, transition) {
        for(var p in places) {
            Store.removeConnection(places[p], transition)
        }
        canvashandler.repaint()
    }

    function freeFromConnections(items) {
        for(var it in items) {
            var item = items[it]

            if(item.isPlace) {
                if(item.inbound) {
                    Store.removeConnection(item, indexhandler.connection(item.inbound).getTransition())
                }

                if(item.outbound) {
                    Store.removeConnection(item, indexhandler.connection(item.outbound).getTransition())
                }
            } else if(item.isTransition) {
                var inbound_count = item.inbound.length
                for(var idx = inbound_count; idx--;) {
                    Store.removeConnection(item, indexhandler.connection(item.inbound[idx]).getPlace())
                }

                var outbound_count = item.outbound.length
                for(var odx = outbound_count; odx--;) {
                    Store.removeConnection(item, indexhandler.connection(item.outbound[odx]).getPlace())
                }
            }
        }
        canvashandler.repaint()
    }
}
