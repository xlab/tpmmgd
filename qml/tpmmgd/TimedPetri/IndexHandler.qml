import QtQuick 2.0
import "IndexHandler.js" as Store

Item {
    id: ih
    property var places: Store.places
    property var transitions: Store.transitions
    property var connections: Store.connections

    function addPlace(place) {
        Store.addPlace(place)
    }

    function removePlace(place) {
        Store.removePlace(place)
    }

    function addTransition(transition) {
        Store.addTransition(transition)
    }

    function removeTransition(transition) {
        Store.removeTransition(transition)
    }

    function addConnection(connection) {
        Store.addConnection(connection)
    }

    function removeConnection(connection) {
        Store.removeConnection(connection)
    }

    function place(place) {
        return Store.places[place]
    }

    function trasition(transition) {
        return Store.transitions[transition]
    }

    function connection(connection) {
        return Store.connections[connection]
    }

    function wtf(something) {
        if(Store.places[something]) {
            return Store.places[something]
        } else {
            return Store.transitions[something]
        }
    }

    function generateUUID() {
        return ++Store.offset
    }

    // used to prefix loaded items if
    // they're doubling the existing ones
    function generateLUUID() {
        return ++Store.loffset
    }

    function removeItems(items) {
        var items_count = items.length
        for(var idx = items_count; idx--;) {
            if(items[idx].isPlace) {
                Store.removePlace(items[idx].objectName)
            } else {
                Store.removeTransition(items[idx].objectName)
            }
        }
    }
}
