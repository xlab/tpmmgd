var routes = []
var offset = 0

function addRoute(items) {
    var arr = []
    for(var it in items) {
        arr.push(items[it].objectName)
    }

    routes[genUUID()] = arr
}

function removeRoute(uid) {
    delete routes[uid]
}

function genUUID() {
    return "route" + (++offset)
}

function check(item, route) {
    for(var it in routes[route]) {
        if(it === item) {
            return true
        }
    }
    return false
}
