var places = {}
var transitions = {}
var connections = {}
var offset = 0
var loffset = 0

function addPlace(place) { // by object
    console.assert(place.isPlace, "Supplied place isn't a place!")
    places[place.objectName] = place
}

function removePlace(place) { // by id
    places[place].destroy()
    delete places[place]
}

function addTransition(transition) { // by object
    console.assert(transition.isTransition, "Supplied transition isn't a transition!")
    transitions[transition.objectName] = transition
}

function removeTransition(transition) { // by id
    transitions[transition].destroy()
    delete transitions[transition]
}

function addConnection(connection) { // by object
    console.assert(connection.isConnection, "Supplied connection isn't a connection!")
    connections[connection.objectName] = connection
}

function removeConnection(connection) { // by id
    connections[connection].destroy()
    delete connections[connection]
}

