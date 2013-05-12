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

    function describeSystem(U, X, Y, A, B, C) {
        // U - sources, X - regular, Y - sinks
        var mA = MathEvaluator.printMatrice(A)
        var mB = MathEvaluator.printMatrice(B)
        var mC = MathEvaluator.printMatrice(C)

        var zA = (rows(mA) > 0 && columns(mA) > 0 && mA[0] === "eps") ? true : false
        var zB = (rows(mB) > 0 && columns(mB) > 0 && mB[0] === "eps") ? true : false
        var zC = (rows(mC) > 0 && columns(mC) > 0 && mC[0] === "eps") ? true : false

        var X_available = (X.length > 0 && rows(mA) > 0 && columns(mA) > 0)
        var U_available = (U.length > 0 && rows(mB) > 0 && columns(mB) > 0 && !zB)
        var Y_available = (X.length > 0 && Y.length > 0 && rows(mC) > 0 && columns(mC) > 0 && !zC)

        var str = "$"
        var cases = false

        if(X_available && !zA) {
            if(Y_available) {
                str += "\\\\begin{cases}"
                cases = true
            }

            str += drawVector(X) + " \\\\geq " + drawMatrice(mA) + drawVector(X) // X = AX
            if(U_available) {
                str += " \\\\oplus "
            } else {
                str += "\\\\\\\\"
            }
        } else if (X_available && U_available) {
            if(Y_available) {
                str += "\\\\begin{cases}"
                cases = true
            }

            str += drawVector(X) + " \\\\geq "
        }

        if(U_available) {
            str += drawMatrice(mB) + drawVector(U) // + BU
            str += "\\\\\\\\"
        }

        if(Y_available) {
            str += drawVector(Y) + " \\\\geq " + drawMatrice(mC) + drawVector(X) // Y = CX

            if(cases) {
                str += "\\\\end{cases}"
            }
        }
        str += "$"

        setText(str)
    }

    function rows(H) {
        return H.length
    }

    function columns(H) {
        if(rows(H) > 0) {
            return H[0].length
        } else {
            return 0
        }
    }

    function drawVector(H) {
        if(rows(H) < 1 || columns(H) < 1) {
            return
        }

        if(rows(H) < 2) {
            return makeVar(H[0])
        } else {
            var str = "\\\\begin{pmatrix}"

            for(var r in H) {
                str += makeVar(H[r])
                if(r < rows(H) - 1) {
                    str += " \\\\\\\\ "
                }
            }

            str += "\\\\end{pmatrix}"
            return str
        }
    }

    function drawMatrice(H) {
        if(rows(H) < 2 && columns(H) < 2) {
            return " " + makeSerie(H[0][0]) + " "
        } else {
            var str = "\\\\begin{pmatrix}"

            for(var r in H) {
                for(var c in H[r]) {
                    str += makeSerie(H[r][c])

                    if(c < columns(H) - 1) {
                        str += " & "
                    }
                }

                if(r < rows(H) - 1) {
                    str += " \\\\\\\\ "
                }
            }

            str += "\\\\end{pmatrix}"
            return str
        }
    }

    function makeVar(arg) {
        arg = arg.replace(/([^0-9_]+)([\d]+)/g, "$1_{$2}")
        arg = arg.replace(/_([\d]+)/g, "_{$1}")
        return arg
    }

    function makeSerie(arg) {
        arg = arg.replace(" + ", " \\\\oplus ")
        arg = arg.replace("g^0", "")
        arg = arg.replace("d^0", "")
        arg = arg.replace("g", "\\\\gamma")
        arg = arg.replace("d", "\\\\delta")
        arg = arg.replace("eps", "\\\\varepsilon")
        arg = arg.replace("[", "(")
        arg = arg.replace("]*", ")\\\\star")
        arg = arg.replace(/\^([0-9]+)/g, "^{$1}")
        arg = arg.replace(/\^\{1\}/g, "")
        return arg
    }

}
