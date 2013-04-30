var connected = {}

function addConnectionOutbound(place, transition) {
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

function addConnectionInbound(transition, place) {
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
            successor.removeOutbound(connectionId)
        } else if(successor.hasInbound(predecessor.outbound)) {
            connectionId = predecessor.outbound
            predecessor.outbound = ''
            successor.removeInbound(connectionId)
        } else {
            return
        }
    } else {
        place = successor
        transition = predecessor

        if(predecessor.hasInbound(successor.outbound)) {
            connectionId = successor.outbound
            successor.outbound = ''
            predecessor.removeInbound(connectionId)
        } else if (predecessor.hasOutbound(successor.inbound)) {
            connectionId = successor.inbound
            successor.inbound = ''
            predecessor.removeOutbound(connectionId)
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
