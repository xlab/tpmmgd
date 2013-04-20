import QtQuick 2.0
import "IndexHandler.js" as Store

Item {
    id: ih

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
        return Store.connection[connection]
    }

    function generateUUID() {
        return ++Store.offset
    }
}
