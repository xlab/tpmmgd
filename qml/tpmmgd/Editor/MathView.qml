import QtQuick 2.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0

Flickable {
    contentHeight: webview.height
    contentWidth: webview.width
    boundsBehavior: "DragAndOvershootBounds"
    clip: true
    property string lorem: {
        var l = ""
        l += "<p class=\"initial\">"
        l += "$"
        l += "\\\\definecolor{silver}{RGB}{189,195,199}"
        l += "\\\\color{silver}\\\\huge{MathView}"
        l += "$"
        l += "</p>"
        return l
    }

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

    function isEmpty(H) {
        return rows(H) < 1 || columns(H) < 1
    }

    function render(U, X, Y, A, B, C) {
        var str = "$"
        var describe = describeSystem(U, X, Y, A, B, C)

        if(!(describe.length < 1 || isEmpty(U) ||
             isEmpty(X) || isEmpty(Y) || isEmpty(matrice(A)) ||
             isEmpty(matrice(B)) || isEmpty(matrice(C)))) {
            str += describe
            str += " \\\\\\\\ "
            str += " \\\\\\\\ "
            str += solveSystem(U, X, Y, A, B, C)
        }

        str += "$"

        if(str === "$$") {
            setText(lorem)
        } else {
            setText(str)
        }
    }

    function describeSystem(U, X, Y, A, B, C) {
        // U - sources, X - regular, Y - sinks
        var mA = MathEvaluator.printMatrice(A)
        var mB = MathEvaluator.printMatrice(B)
        var mC = MathEvaluator.printMatrice(C)

        // Check if matrice is zero
        var zA = (rows(mA) < 1 || columns(mA) < 1 || mA[0] === "eps") ? true : false
        var zB = (rows(mB) < 1 || columns(mB) < 1 || mB[0] === "eps") ? true : false
        var zC = (rows(mC) < 1 || columns(mC) < 1 || mC[0] === "eps") ? true : false

        // Check if X/U/Y
        var X_available = (X.length > 0)
        var U_available = (U.length > 0 && !zB)
        var Y_available = (X_available && Y.length > 0 && !zC)

        var str = "\\\\text{Model:}" + " \\\\\\\\ "
        var cases = false
        var smth = false

        if(X_available && !zA) {
            if(Y_available) {
                str += "\\\\begin{cases}"
                cases = true
            }

            str += drawVector(X) + " \\\\geq " + drawMatrice(mA) + drawVector(X) // X = AX

            if(U_available) {
                str += " \\\\oplus "
            } else {
                str += " \\\\\\\\ "
            }

            smth = true
        } else if (X_available && U_available) {
            if(Y_available) {
                str += "\\\\begin{cases}"
                cases = true
            }

            str += drawVector(X) + " \\\\geq "
            smth = true
        }

        if(U_available) {
            str += drawMatrice(mB) + drawVector(U) // + BU
            str += " \\\\\\\\ "
            smth = true
        }

        if(Y_available) {
            str += drawVector(Y) + " \\\\geq " + drawMatrice(mC) + drawVector(X) // Y = CX

            if(cases) {
                str += "\\\\end{cases}"
            }

            smth = true
        }

        if(smth) {
            return str
        } else {
            return ""
        }
    }

    function solveSystem(U, X, Y, A, B, C) {
        // Y = (CA*B)U
        // solution
        var str = "\\\\text{The least solution:}" + " \\\\\\\\ "
        str += "\\\\begin{matrix}"
        str += "\\\\begin{cases}"
        str += "X = (A^\\\\star B) U" + " \\\\\\\\ "
        str += "Y = CX = (C A^\\\\star B) U"
        str += "\\\\end{cases}"
        str += "& \\\\\Rightarrow &"
        str += "\\\\boxed{ " + drawVector(Y) + " = " + drawMatrice(printMatrice(otimes2(otimes2(C, star2(A)), B))) + " " + drawVector(U) + "}"
        str += "\\\\end{matrix}"
        return str;
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
                    str += "  \\\\\\\\  "
                }
            }

            str += "\\\\end{pmatrix}"
            return str
        }
    }

    function drawMatrice(H) {
        if(H[0] === "eps") {
            return makeSerie("eps")
        } else if(rows(H) < 2 && columns(H) < 2) {
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
                    str += "  \\\\\\\\  "
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
        arg = arg.replace(/ + /g, " \\\\oplus ")
        arg = arg.replace(/g\^0/g, "")
        arg = arg.replace(/d\^0/g, "")
        arg = arg.replace(/g/g, "\\\\gamma")
        arg = arg.replace(/d/g, "\\\\delta")
        arg = arg.replace(/eps/g, "\\\\varepsilon")
        arg = arg.replace(/\[/g, "(")
        arg = arg.replace(/\]\*/g, ")^\\\\star")
        arg = arg.replace(/\^([0-9]+)/g, "^{$1}")
        arg = arg.replace(/\^\{1\}/g, "")
        arg = arg.replace(/\^\{2147483647\}/g, "^{\\\\infty}")
        arg = arg.replace(/\^\{-2147483647\}/g, "^{-\\\\infty}")
        return arg
    }

    function serie(serie1) {
        return MathEvaluator.series(serie1)
    }

    function matrice(matrice1) {
        return MathEvaluator.matrice(matrice1)
    }

    function oplus(serie1, serie2) {
        return MathEvaluator.oplusSeries(serie1, serie2)
    }

    function oplus2(matrice1, matrice2) {
        return MathEvaluator.oplusMatrices(matrice1, matrice2)
    }

    function otimes(serie1, serie2) {
        return MathEvaluator.otimesSeries(serie1, serie2)
    }

    function otimes2(matrice1, matrice2) {
        if(columns(matrice1) !== rows(matrice2)) {
            console.log("Matrices are incompatible")
            return
        }

        return MathEvaluator.otimesMatrices(matrice1, matrice2)
    }

    function star(serie1) {
        return MathEvaluator.starSerie(serie1)
    }

    function star2(matrice1) {
        return MathEvaluator.starMatrice(matrice1)
    }

    function printSerie(serie1) {
        return MathEvaluator.printSerie(serie1)
    }

    function printMatrice(matrice1) {
        return MathEvaluator.printMatrice(matrice1)
    }
}
