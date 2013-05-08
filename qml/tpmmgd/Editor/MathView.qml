import QtQuick 2.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0

Flickable {
    contentHeight: webview.height
    contentWidth: webview.width
    boundsBehavior: "DragAndOvershootBounds"
    clip: true

    WebView {
        id: webview
        height: 2000
        width: 2000
        url: 'math.html'
    }

    function setText(text) {
        webview.experimental.evaluateJavaScript(
                    "(function(){" +
                    "document.getElementById('text').innerHTML = '" + text + "';" +
                    "MathJax.Hub.Queue(['Typeset', MathJax.Hub, 'text']); })()")
    }
}
