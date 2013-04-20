var focused = []

function addItem(item) {
    focused.push(item)
}

function clear() {
    focused = []
}

function what(obj) {
  return ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()
}
