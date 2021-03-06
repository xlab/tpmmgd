import QtQuick 2.0
import QtWebKit 3.0
import QtWebKit.experimental 1.0
import '../TimedPetri'

Flickable {
    contentHeight: webview.height
    contentWidth: webview.width
    boundsBehavior: "DragAndOvershootBounds"
    clip: true
    property string laststr: "lorem"

    WebView {
        id: webview
        height: 2000
        width: 2000
        url: 'math.html'

        onLoadingChanged: {
            if(loadRequest.status === WebView.LoadSucceededStatus) {
                laststr = "lorem"
            }
        }
    }

    function setText(text) {
        webview.experimental.evaluateJavaScript('setText("' + text + '")')
    }

    function isEmpty(H) {
        return rows(H) < 1 || columns(H) < 1
    }

    function render(U, X, Y, A, B, C, A_highlight, B_highlight, C_highlight, highlight) {
        var str = "$"
        var describe = describeSystem(U, X, Y, A, B, C, A_highlight, B_highlight, C_highlight, highlight)

        if(!(describe.length < 1 || isEmpty(U) ||
             isEmpty(X) || isEmpty(Y) || isEmpty(matrice(A)) ||
             isEmpty(matrice(B)) || isEmpty(matrice(C)))) {
            str += describe
            str += " \\\\\\\\ "
            str += " \\\\\\\\ "
            str += solveSystem(U, X, Y, A, B, C)
            str += " \\\\\\\\[1cm] "
        }

        str += describeEvaluations()
        str += "$"

        if(str === "$$") {
            if(laststr !== "") {
                laststr = ""
                webview.experimental.evaluateJavaScript('lorem()')
            }
        } else {
            if(str !== laststr) {
                laststr = str
                setText(str)
            }
        }
    }

    function describeSystem(U, X, Y, A, B, C, A_highlight, B_highlight, C_highlight, highlight) {
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

            str += drawVector(X, highlight) + " \\\\geq " + drawMatrice(mA, A_highlight) + drawVector(X, highlight) // X = AX

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

            str += drawVector(X, highlight) + " \\\\geq "
            smth = true
        }

        if(U_available) {
            str += drawMatrice(mB, B_highlight) + drawVector(U, highlight) // + BU
            str += " \\\\\\\\ "
            smth = true
        }

        if(Y_available) {
            str += drawVector(Y, highlight) + " \\\\geq " + drawMatrice(mC, C_highlight) + drawVector(X, highlight) // Y = CX

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

    function describeEvaluations() {
        if(!codeview.declared || codeview.declared.length < 1) {
            return ""
        }

        var str = "\\\\text{User's evaluations:}" + " \\\\\\\\ "

        for(var i in codeview.declared) {
            var item = codeview.declared[i]
            str += makeId(item.id) + " = "
            if(item.type === "smatrix") {
                str += drawMatrice(printMatrice(item.data))
            } else if(item.type === "serie") {
                str += makeSerie(printSerie(item.data))
            }

            if(i < codeview.declared.length - 1) {
                str += " \\\\\\\\ "
            }
        }
        return str
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

    function needHl(highlight, name) {
        if(!highlight) {
            return false
        }

        if(highlight.indexOf(name) > -1) {
            return true
        }

        return false
    }

    function drawVector(H, highlight) {
        if(rows(H) < 1 || columns(H) < 1) {
            return
        }

        if(rows(H) < 2) {
            return makeVar(H[0], needHl(highlight, H[0]))
        } else {
            var str = "\\\\begin{pmatrix}"

            for(var r in H) {
                str += makeVar(H[r], needHl(highlight, H[r]))
                if(r < rows(H) - 1) {
                    str += "  \\\\\\\\  "
                }
            }

            str += "\\\\end{pmatrix}"
            return str
        }
    }

    function drawMatrice(H, H_highlight) {
        var highlight = true
        if(!H_highlight)
        {
            highlight = false
        }

        if(H[0] === "eps") {
            return makeSerie("eps")
        } else if(rows(H) < 2 && columns(H) < 2) {
            return " " + makeSerie(H[0][0], highlight ? H_highlight[r][c] : false) + " "
        } else {
            var str = "\\\\begin{pmatrix}"

            for(var r in H) {
                for(var c in H[r]) {
                    str += makeSerie(H[r][c], highlight ? H_highlight[r][c] : false)

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

    function makeVar(arg, highlight) {
        arg = arg.replace(/([^0-9_]+)([\d]+)/g, "$1_{$2}")
        arg = arg.replace(/_([\d]+)/g, "_{$1}")

        if(highlight) {
            arg = "\\\\definecolor{flatred}{RGB}{192,57,43}\\\\color{flatred}" + arg + "\\\\color{black}"
        }

        return arg
    }

    function makeSerie(arg, highlight) {
        arg = arg.replace(/\+/g, " \\\\oplus ")
        arg = arg.replace(/g\^\{0\}/g, "")
        arg = arg.replace(/d\^\{0\}/g, "")
        arg = arg.replace(/g/g, "\\\\gamma")
        arg = arg.replace(/d/g, "\\\\delta")
        arg = arg.replace(/eps/g, "\\\\varepsilon")
        arg = arg.replace(/\[/g, "(")
        arg = arg.replace(/\]\*/g, ")^\\\\star")
        arg = arg.replace(/\^([0-9]+)/g, "^{$1}")
        arg = arg.replace(/\^\{1\}/g, "")
        arg = arg.replace(/\^\{2147483647\}/g, "^{\\\\infty}")
        arg = arg.replace(/\^\{-2147483647\}/g, "^{-\\\\infty}")

        if(highlight) {
            arg = "\\\\definecolor{flatred}{RGB}{192,57,43}\\\\color{flatred}" + arg + "\\\\color{black}"
        }

        return arg
    }

    function makeId(arg) {
        arg = arg.replace(/([^0-9_]+)([\d]+)/g, "$1_{$2}")
        arg = arg.replace(/_([\d]+)/g, "_{$1}")
        arg = arg.replace(/\+/g, " \\\\oplus ")
        arg = arg.replace(/\)\*/g, ")^\\\\star")
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
