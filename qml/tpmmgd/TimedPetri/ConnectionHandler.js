var connected = {}

function addConnectionInbound(place, transition) {
    console.assert(transition.isTransition, "Supplied transition isn't a transition!")
    console.assert(place.isPlace, "Supplied place isn't a place!")

    if(!connected[place.objectName]) {
        connected[place.objectName] = {}
    }
    connected[place.objectName][transition.objectName] = 1

    var name = "connection" + indexhandler.generateUUID()

    place.outbound = name
    transition.addInbound(name)
    return name
}

function addConnectionOutbound(transition, place) {
    console.assert(transition.isTransition, "Supplied transition isn't a transition!")
    console.assert(place.isPlace, "Supplied place isn't a place!")

    if(!connected[place.objectName]) {
        connected[place.objectName] = {}
    }
    connected[place.objectName][transition.objectName] = -1

    var name = "connection" + indexhandler.generateUUID()

    place.inbound = name
    transition.addOutbound(name)
    return name
}

function removeConnection(predecessor, successor) {
    var connectionId
    var place
    var transition

    if(predecessor.isPlace) {
        place = predecessor
        transition = successor

        if (successor.hasOutbound(predecessor.inbound)) {
            connectionId = predecessor.inbound
            predecessor.inbound =  ''
            predecessor.octrl = null
            successor.removeOutbound(connectionId)
            successor.sortOutbound()
        } else if(successor.hasInbound(predecessor.outbound)) {
            connectionId = predecessor.outbound
            predecessor.outbound = ''
            predecessor.ictrl = null
            successor.removeInbound(connectionId)
            successor.sortInbound()
        } else {
            return
        }
    } else {
        place = successor
        transition = predecessor

        if(predecessor.hasInbound(successor.outbound)) {
            connectionId = successor.outbound
            successor.outbound = ''
            successor.ictrl = null
            predecessor.removeInbound(connectionId)
            predecessor.sortInbound()
        } else if (predecessor.hasOutbound(successor.inbound)) {
            connectionId = successor.inbound
            successor.inbound = ''
            successor.octrl = null
            predecessor.removeOutbound(connectionId)
            predecessor.sortOutbound()
        } else {
            return
        }
    }

    connected[place.objectName][transition.objectName] = 0
    indexhandler.removeConnection(connectionId)
}

function check(place, transition) {
    if (!connected[place.objectName]) return 0
    return connected[place.objectName][transition.objectName];
}
