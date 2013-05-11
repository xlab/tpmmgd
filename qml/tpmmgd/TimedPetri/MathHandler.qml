import QtQuick 2.0
import "MathHandler.js" as Store

Item {
    property IndexHandler ih

    function gatherInfo(x1, x2) {
        var t1 = ih.transitions[x1]
        var t2 = ih.transitions[x2]
        var info = []

        for(var c in t2.inbound) {
            var place = ih.connection(t2.inbound[c]).getPlace()
            var place_inbound = ih.connection(place.inbound)
            if(place_inbound.getTransition().objectName === x1) {
                info.push([place.tokens, place.bars])
            }
        }

        if(info.length < 1) {
            return [[0,0]]
        }

        return info
    }

    function updateMatrices() {
        var transitions = []
        Store.sources = []
        Store.sinks = []
        Store.regular = []

        for(var tid in ih.transitions) {
            var t = ih.transitions[tid]
            if(t.labelText) {
                transitions[t.labelText] = t

                if(t.inbound.length && !t.outbound.length) {
                    Store.sinks.push(t.labelText)
                } else if (!t.inbound.length && t.outbound.length) {
                    Store.sources.push(t.labelText)
                } else {
                    Store.regular.push(t.labelText)
                }
            }
        }

        Store.sources.sort()
        Store.sinks.sort()
        Store.regular.sort()

        Store.A = []
        for(var x1 in Store.regular) {
            var A_row = []
            for(var x2 in Store.regular) {
                var l1 = Store.regular[x1]
                var l2 = Store.regular[x2]
                A_row.push(gatherInfo(transitions[l1].objectName, transitions[l2].objectName))
            }
            Store.A.push(A_row)
        }

        Store.B = []
        for(var x1 in Store.regular) {
            var B_row = []
            for(var x2 in Store.sources) {
                var l2 = Store.regular[x1]
                var l1 = Store.sources[x2]
                B_row.push(gatherInfo(transitions[l1].objectName, transitions[l2].objectName))
            }
            Store.B.push(B_row)
        }

        Store.C = []
        for(var x1 in Store.sinks) {
            var C_row = []
            for(var x2 in Store.regular) {
                var l1 = Store.regular[x2]
                var l2 = Store.sinks[x1]
                C_row.push(gatherInfo(transitions[l1].objectName, transitions[l2].objectName))
            }
            Store.C.push(C_row)
        }
    }

    function sources() {
        return Store.sources
    }

    function sinks() {
        return Store.sinks
    }

    function regular() {
        return Store.regular
    }

    function getA() {
        return Store.A
    }

    function getB() {
        return Store.B
    }

    function getC() {
        return Store.C
    }
}
