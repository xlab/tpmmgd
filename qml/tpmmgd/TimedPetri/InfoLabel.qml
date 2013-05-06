import QtQuick 2.0

Text {
    property string standart: "Timed Petri MinMax[γ,δ] by Maxim Kouprianov | 2013"
    property var iohelper
    id: label
    color: "#34495e"
    font.pixelSize: 16
    text: label.standart

    function showPath() {
        text = "File path: " + iohelper.path
        resetLabelTimer.restart()
    }

    function screenshot() {
        text = "Screenshot has been taken"
        resetLabelTimer.restart()
    }

    function saveSuccess() {
        text = "Saved successfully"
        resetLabelTimer.restart()
    }
    function loadSuccess() {
        text = "Loaded successfully"
        resetLabelTimer.restart()
    }

    function saveFail() {
        text = "Writing to file failed"
        resetLabelTimer.restart()
    }

    function loadFail() {
        text = "Reading from file failed"
        resetLabelTimer.restart()
    }

    Timer {
        id: resetLabelTimer
        interval: 5000
        onTriggered: label.text = label.standart
    }
}
