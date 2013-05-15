import QtQuick 2.0
import "../Editor"
import "MathHandler.js" as Store

Item {
    property IndexHandler ih
    property FocusHandler fh
    property MathView mathview

    Timer {
        id: clock
        running: true
        repeat: true
        interval: 100
        onTriggered: {
            mathview.render(Store.sources, Store.regular, Store.sinks, Store.A, Store.B, Store.C,
                            Store.A_highlight, Store.B_highlight, Store.C_highlight, Store.highlight)
        }
    }

    function gatherInfo(x1, x2) {
        var t1 = ih.transitions[x1]
        var t2 = ih.transitions[x2]
        var info = []

        for(var c in t2.inbound) {
            var place = ih.connection(t2.inbound[c]).getPlace()
            var place_inbound = ih.connection(place.inbound)
            if(place_inbound && place_inbound.getTransition().objectName === x1) {
                info.push([place.tokens, place.bars])
            }
        }

        if(info.length < 1) {
            return [MathEvaluator.gd_epsilon]
        }

        return info
    }

    function isPlaceSelected(x1, x2) {
        var t1 = ih.transitions[x1]
        var t2 = ih.transitions[x2]
        var info = []

        for(var c in t2.inbound) {
            var place = ih.connection(t2.inbound[c]).getPlace()
            var place_inbound = ih.connection(place.inbound)
            if(place_inbound && place_inbound.getTransition().objectName === x1) {
                if(fh.focused().indexOf(place) > -1) {
                    return true
                }
            }
        }

        return false
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
                } else if (t.inbound.length && t.outbound.length) {
                    Store.regular.push(t.labelText)
                }
            }
        }

        Store.sources.sort()
        Store.sinks.sort()
        Store.regular.sort()

        Store.A = []
        Store.A_highlight = []
        for(var x1 in Store.regular) {
            var A_row = []
            var A_h_row = []
            for(var x2 in Store.regular) {
                var l1 = Store.regular[x1]
                var l2 = Store.regular[x2]
                A_row.push(gatherInfo(transitions[l1].objectName, transitions[l2].objectName))
                A_h_row.push(isPlaceSelected(transitions[l1].objectName, transitions[l2].objectName))
            }
            Store.A.push(A_row)
            Store.A_highlight.push(A_h_row)
        }

        Store.B = []
        Store.B_highlight = []
        for(var x1 in Store.regular) {
            var B_row = []
            var B_h_row = []
            for(var x2 in Store.sources) {
                var l2 = Store.regular[x1]
                var l1 = Store.sources[x2]
                B_row.push(gatherInfo(transitions[l1].objectName, transitions[l2].objectName))
                B_h_row.push(isPlaceSelected(transitions[l1].objectName, transitions[l2].objectName))
            }
            Store.B.push(B_row)
            Store.B_highlight.push(B_h_row)
        }

        Store.C = []
        Store.C_highlight = []
        for(var x1 in Store.sinks) {
            var C_row = []
            var C_h_row = []
            for(var x2 in Store.regular) {
                var l1 = Store.regular[x2]
                var l2 = Store.sinks[x1]
                C_row.push(gatherInfo(transitions[l1].objectName, transitions[l2].objectName))
                C_h_row.push(isPlaceSelected(transitions[l1].objectName, transitions[l2].objectName))
            }
            Store.C.push(C_row)
            Store.C_highlight.push(C_h_row)
        }

        updateHighlight()
    }

    function updateHighlight() {
        Store.highlight = []
        for(var i in fh.focused()) {
            var it = fh.focused()[i]
            if(it.isTransition && it.labelText) {
                Store.highlight.push(it.labelText)
            }
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

    function series(data) {
        if(data == undefined) {
            return
        }

        return MathEvaluator.series(data)
    }

    function matrice(data) {
        if(data == undefined) {
            return
        }

        return MathEvaluator.matrice(data)
    }

    function oplus(data1, data2) {
        if(data1.data == undefined ||
                data2.data == undefined) {
            return
        }

        if(data1.type === "smatrix" && data2.type === "smatrix") {
            var a = MathEvaluator.matrice(data1.data)
            var b = MathEvaluator.matrice(data2.data)
            return MathEvaluator.oplusMatrices(a, b)
        } else if(data1.type === "serie" && data2.type === "serie") {
            var a = MathEvaluator.series(data1.data)
            var b = MathEvaluator.series(data2.data)
            return MathEvaluator.oplusSeries(a, b)
        }
    }

    function otimes(data1, data2) {
        if(data1.data == undefined ||
                data2.data == undefined) {
            return
        }

        if(data1.type === "smatrix" && data2.type === "smatrix") {
            var a = MathEvaluator.matrice(data1.data)
            var b = MathEvaluator.matrice(data2.data)
            return MathEvaluator.otimesMatrices(a, b)
        } else if(data1.type === "serie" && data2.type === "serie") {
            var a = MathEvaluator.series(data1.data)
            var b = MathEvaluator.series(data2.data)
            return MathEvaluator.otimesSeries(a, b)
        }
    }

    function star(data) {
        if(data.data == undefined) {
            return
        }

        if(data.type === "smatrix") {
            var a = MathEvaluator.matrice(data.data)
            return MathEvaluator.starMatrice(a)
        } else if(data.type === "serie") {
            var a = MathEvaluator.series(data.data)
            return MathEvaluator.starSerie(a)
        }
    }
}
