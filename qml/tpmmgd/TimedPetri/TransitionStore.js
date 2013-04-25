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

function sort(what) {
    var arr = (what === 'inbound') ? inbound : outbound
    arr.sort(ySort)
}

function ySort(item1, item2) {
    var y1 = indexhandler.connection(item1).getPlace().centerY
    var y2 = indexhandler.connection(item2).getPlace().centerY

    if(y1 < y2) {
        return -1
    } else if(y1 > y2) {
        return 1
    }

    return 0
}
