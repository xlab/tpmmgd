import QtQuick 2.0
import 'TimedPetri'

Rectangle {
    width: 800
    height: 600

    TimedPetri {
        id: tp
        anchors.fill: parent
        anchors.bottomMargin: 30
    }

    Component.onCompleted: {
        IOHelper.pathChanged.connect(label.pathToLabel)
        IOHelper.screenshotCompleted.connect(label.screenshot)
        IOHelper.saveSuccess.connect(label.saveSuccess)
        IOHelper.loadSuccess.connect(label.loadSuccess)
        IOHelper.saveFail.connect(label.saveFail)
        IOHelper.loadFail.connect(label.loadFail)
        IOHelper.saveReady.connect(saveNet)
        IOHelper.loadReady.connect(loadNet)
    }

    function requestSaveNet() {
        if(!IOHelper.path) {
            IOHelper.saveDialog()
        } else {
            saveNet()
        }
    }

    function saveNet() {
        console.log("Writing file")
        NetContainer.clear()
        for(var place in tp.indexhandler.places) {
            var p = tp.indexhandler.places[place]
            NetContainer.addPlace(p.x, p.y, p.tokens, 0, p.inbound, p.outbound)
        }

        IOHelper.save()
    }

    function requestReloadNet() {
        if(!IOHelper.path) {
            IOHelper.loadDialog()
        } else {
            loadNet()
        }
    }

    function loadNet() {
        console.log("Loading file")
        NetContainer.clear()
        IOHelper.load()

        for(var i = NetContainer.places.length; i--;) {
            var p = NetContainer.places[i]
            tp.addMarkedPlace(p.x, p.y, p.tokens, 0)
        }
    }

    Rectangle {
        id: panel
        height: 40
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: "#f4f4f4"
        border.color: "#c4c4c4"

        Item {
            id: openbutton
            width: 20
            height: 20
            anchors.left: panel.left
            anchors.bottom: panel.bottom
            anchors.margins: 10

            Rectangle {
                color: "red"
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: requestReloadNet()
            }
        }

        Item {
            id: savebutton
            width: 20
            height: 20
            anchors.left: openbutton.right
            anchors.bottom: panel.bottom
            anchors.margins: 10

            Rectangle {
                color: "green"
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: requestSaveNet()
            }
        }

        Item {
            id: screenshotbutton
            width: 20
            height: 20
            anchors.left: savebutton.right
            anchors.bottom: panel.bottom
            anchors.margins: 10

            Rectangle {
                color: "blue"
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Showing screenshot saving dialog")
                    //IOHelper.saveDialog()
                }
            }
        }

        Text {
            property string standart: "Timed Petri MinMax[γ,δ] by Maxim Kouprianov | 2013"
            id: label
            z: 9
            anchors {
                right: panel.right
                bottom: panel.bottom
                rightMargin: 10
                bottomMargin: 10
            }
            color: "#545454"
            font.pixelSize: 16
            text: label.standart

            function pathToLabel() {
                label.text = "File path: " + IOHelper.path
                resetLabelTimer.restart()
            }

            function screenshot() {
                label.text = "Screenshot has been taken"
                resetLabelTimer.restart()
            }

            function saveSuccess() {
                label.text = "Saved succesfully"
                resetLabelTimer.restart()
            }
            function loadSuccess() {
                label.text = "Loaded succesfully"
                resetLabelTimer.restart()
            }

            function saveFail() {
                label.text = "Save failed"
                resetLabelTimer.restart()
            }

            function loadFail() {
                label.text = "Load failed"
                resetLabelTimer.restart()
            }

            Timer {
                id: resetLabelTimer
                interval: 5000
                onTriggered: label.text = label.standart
            }
        }
    }
}
 
