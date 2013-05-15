import QtQuick 2.0
import "FocusHandler.js" as Store

Item {
    id: fh
    signal updated

    function addFocusedClick(item, union) {
        if(item.focused && union) return
        if(!union) clearFocused()
        item.focus()
        Store.addItem(item)
        updated()
    }

    function addFocusedPress(item, union) {
        if(item.focused) return
        if(Store.focused.length < 2 && !union) {
            clearFocused()
        }
        item.focus()
        Store.addItem(item)
        updated()
    }

    function removeFocused(item) {
        var arr = Store.focused
        for(var i = arr.length; i--;) {
            if(item === arr[i]) {
                item.unfocus()
                delete arr[i]
                arr.splice(i, 1)
            }
        }

        updated()
    }

    function clearFocused() {
        for(var i = Store.focused.length; i--;) {
            var item = Store.focused[i]
            item.unfocus()
        }

        Store.clear()
        updated()
    }

    function shiftAll(dX, dY) {
        for(var i = Store.focused.length; i--;) {
            var item = Store.focused[i]
            if(!item.beingDragged) {
                item.x += dX
                item.y += dY
            } else if(item.isPlace) {
                if(item.ictrl) item.ictrl.reset()
                if(item.octrl) item.octrl.reset()
            }

            if (item.isTransition) {
                item.shiftControlPoints(dX, dY)
            }
        }
    }

    function focused() {
        return Store.focused
    }

    function count() {
        return Store.focused.length
    }
}
