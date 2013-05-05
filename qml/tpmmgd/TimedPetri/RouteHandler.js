var routes = []

routes.remove = function(from, to) {
  var rest = this.slice((to || from) + 1 || this.length);
  this.length = from < 0 ? this.length + from : from;
  return this.push.apply(this, rest);
};

function addRoute(items) {
    var arr = []
    for(var it in items) {
        arr.push(items[it].objectName)
    }

    routes.push(arr)
}

function removeRoute(uid) {
    routes.remove(uid)
}

function check(item, route) {
    for(var it in routes[route]) {
        if(routes[route][it] === item) {
            return true
        }
    }
    return false
}
