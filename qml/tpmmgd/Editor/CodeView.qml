import QtQuick 2.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0

WebView {
    id: webview
    url: 'code.html'
    property string text
    property var declared
    property bool alive: false
    signal changed

    function push() {
        declared = []
        for(var i in arguments) {
            declared.push(arguments[i])
        }
        console.log(declared.length)
    }

    function gd(data) {
        return {
            type: "gd",
            data: data
        }
    }

    function poly(data) {
        return {
            type: "poly",
            data: data
        }
    }

    function serie(data) {
        return {
            type: "serie",
            data: data
        }
    }

    function smatrix(data) {
        return {
            type: "smatrix",
            data: data
        }
    }

    function evaluate() {
        webview.alive = false
        webview.experimental.evaluateJavaScript("getval()", function(x) {
            try {
                eval(x) // don't care :D
                webview.alive = true
            } catch (e) {
                webview.alive = false
            }

            console.log(webview.alive)
        })
    }
}
