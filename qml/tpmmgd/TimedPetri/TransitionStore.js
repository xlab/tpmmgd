var inbound = []
var outbound = []

function addInbound(item) {
    inbound.push(item)
}

function addOutbound(item) {
    outbound.push(item)
}

function remove(item, from) {
    var arr = (from === 'inbound') ? inbound : outbound
    for(var i = arr.length; i--;) {
        if(item === arr[i]) {
            delete arr[i]
            arr.splice(i, 1)
        }
    }
}

