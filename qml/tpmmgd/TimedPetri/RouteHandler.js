var routes = []

function addRoute(items) {
    var arr = []
    for(var it in items) {
        arr.push(items[it].objectName)
    }

    routes.push(arr)
}

function removeRoute(uid) {
    delete routes[uid]
}

function cleanRoutes() {
    for(var r = routes.length; r--;) {
        if(routes[r] === undefined) {
            routes.splice(r, 1)
        }
    }
}

function check(item, route) {
    for(var it in routes[route]) {
        if(routes[route][it] === item) {
            return true
        }
    }
    return false
}

function setRoutes(new_routes) {
    routes = new_routes
}
