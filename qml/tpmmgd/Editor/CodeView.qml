import QtQuick 2.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import '../TimedPetri'

WebView {
    id: webview
    url: 'code.html'
    property string text
    property var declared
    property bool alive: true
    property bool temp: true
    property MathHandler mh

    function push() {
        declared = []
        for(var i in arguments) {
            if(arguments[i] && arguments[i].id && arguments[i].type) {
                declared.push(arguments[i])
            }
        }
    }

    function serie(id, data) {
        if(!id) {
            fail()
            throw "fail"
        }

        var init = mh.series(data)
        return {
            type: "serie",
            id: id,
            data: init
        }
    }

    function matrix(id, data) {
        if(!id) {
            fail()
            throw "fail"
        }

        var init = mh.matrice(data)
        return {
            type: "smatrix",
            id: id,
            data: init
        }
    }

    function oplus(data1, data2) {
        if(!data1 || !data2) {
            fail()
            throw "fail"
        }

        var type
        var id = data1.id + " + " + data2.id

        if(data1.type === "smatrix" || data2.type === "smatrix")
        {
            type = "smatrix"
        } else if(data1.type === "serie" || data2.type === "serie") {
            type = "serie"
        }

        if(!type) {
            fail()
            throw "fail"
        }

        var data = mh.oplus(data1, data2)

        return {
            type: type,
            id: id,
            data: data
        }
    }

    function otimes(data1, data2) {
        if(!data1 || !data2) {
            fail()
            return
        }

        var type
        var id = "(" + data1.id + ")(" + data2.id + ")"

        if(data1.type === "smatrix" || data2.type === "smatrix")
        {
            type = "smatrix"
        } else if(data1.type === "serie" || data2.type === "serie") {
            type = "serie"
        }

        if(!type) {
            fail()
            throw "fail"
        }

        var data = mh.otimes(data1, data2)

        return {
            type: type,
            id: id,
            data: data
        }
    }

    function star(data1) {
        if(!data1) {
            fail()
            throw "fail"
        }

        var type = data1.type
        var id = "(" + data1.id + ")*"

        if(type !== "smatrix" && type !== "serie") {
            fail()
            throw "fail"
        }

        var data = mh.star(data1)

        return {
            type: type,
            id: id,
            data: data
        }
    }

    function evaluate() {
        webview.temp = false
        declared = []
        webview.experimental.evaluateJavaScript("getval()", function(x) {
            try {
                var e = MathEvaluator.series([MathEvaluator.gd_e])
                var eps = MathEvaluator.series([MathEvaluator.gd_eps])
                var inf = MathEvaluator.inf
                var A = {id: "A", type: "smatrix", data: mh.getA()}
                var B = {id: "B", type: "smatrix", data: mh.getB()}
                var C = {id: "C", type: "smatrix", data: mh.getC()}

                eval(x) // don't care :D
                webview.temp = true
                judge.restart()
            } catch (e) {
                fail()
            }
        })
    }

    function fail() {
        webview.temp = false
        judge.restart()
    }

    Timer {
        id: judge
        interval: 500
        onTriggered: {
            webview.alive = temp
            webview.temp = false
        }
    }

    experimental.preferences.navigatorQtObjectEnabled: true
    experimental.onMessageReceived: {
        evaluate()
    }
}
