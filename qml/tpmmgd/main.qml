import QtQuick 2.0
import 'TimedPetri'
import 'Editor'

Rectangle {
    id: window
    width: 1000
    height: 800

    TimedPetri {
        id: tp
        anchors.top: window.top
        anchors.right: window.right
        anchors.left: window.left
        anchors.bottom: panel.top
        mathhandler: mh
    }

    onHeightChanged: {
        panel.y = window.height * 2/3
    }

    Rectangle {
        id: panel
        height: 40
        color: "#ecf0f1"
        border.color: "#95a5a6"
        anchors {
            left: window.left
            right: window.right
            leftMargin: -1
            rightMargin: -1
        }

        y: window.height * 2/3
        property bool moved: false

        onYChanged: {
            if(!panel.moved && !panel.y) {
                panel.y = window.height * 2/3
            } else if(!panel.moved && panel.x > 0) {
                panel.moved = true
            } else {
                panel.y = Math.min(Math.max(panel.y, 100), window.height - 100)
            }
        }

        MouseArea {
            anchors.fill: parent
            onPressed: drag.target = panel
            onReleased: drag.target = undefined
        }

        LoadButton {
            id: loadbutton
            anchors.left: panel.left
            anchors.leftMargin: 10
            anchors.verticalCenter: panel.verticalCenter
            onClicked: requestReloadNet
            helperlabel: help
        }

        SaveButton {
            id: savebutton
            anchors.left: loadbutton.right
            anchors.leftMargin: 10
            anchors.verticalCenter: panel.verticalCenter
            onClicked: requestSaveNet
            helperlabel: help
        }

        Rectangle {
            id: separator
            anchors.left: savebutton.right
            anchors.leftMargin: 10
            anchors.verticalCenter: panel.verticalCenter
            color: "#95a5a6"
            antialiasing: true
            width: 2
            height: panel.height - 10
        }

        PlaceButton {
            id: placebutton
            anchors.left: separator.right
            anchors.leftMargin: 10
            anchors.bottom: panel.bottom
            anchors.bottomMargin: (panel.height - width) / 2
            activeHeight: (panel.height - 20) / 2 + 20
            timedpetri: tp
            helperlabel: help
        }

        TransitionButton {
            id: transitionbutton
            anchors.left: placebutton.right
            anchors.leftMargin: 10
            anchors.bottom: panel.bottom
            anchors.bottomMargin: (panel.height - width) / 2
            activeHeight: (panel.height - 20) / 2 + 20
            timedpetri: tp
            helperlabel: help
        }

        Rectangle {
            id: separator2
            anchors.left: transitionbutton.right
            anchors.leftMargin: 10
            anchors.verticalCenter: panel.verticalCenter
            color: "#95a5a6"
            antialiasing: true
            width: 2
            height: panel.height - 10
        }

        GenericButton {
            id: anywaybutton
            anchors.left: separator2.right
            anchors.leftMargin: 10
            anchors.verticalCenter: panel.verticalCenter
            helperlabel: help
            onClicked: mh.updateMatrices
        }

        HelperLabel {
            z: 9
            id: help
            anchors.left: panel.left
            anchors.bottom: panel.top
            anchors.leftMargin: 10
            anchors.bottomMargin: 5
        }

        InfoLabel {
            z: 9
            id: info
            anchors.right: panel.right
            anchors.rightMargin: 10
            anchors.verticalCenter: panel.verticalCenter
            iohelper: IOHelper
        }
    }

    MathHandler {
        id: mh
        ih: tp.indexhandler
        mathview: editor.mathview
    }

    Editor {
        id: editor
        anchors.top: panel.bottom
        anchors.left: window.left
        anchors.right: window.right
        anchors.bottom: window.bottom
    }

    Component.onCompleted: {
        IOHelper.pathChanged.connect(info.showPath)
        IOHelper.screenshotCompleted.connect(info.screenshot)
        IOHelper.saveSuccess.connect(info.saveSuccess)
        IOHelper.loadSuccess.connect(info.loadSuccess)
        IOHelper.saveFail.connect(info.saveFail)
        IOHelper.loadFail.connect(info.loadFail)
        IOHelper.saveReady.connect(saveNet)
        IOHelper.loadReady.connect(loadNet)
    }

    function toContainer() {
        NetContainer.clear()

        for(var place in tp.indexhandler.places) {
            var p = tp.indexhandler.places[place]
            var cpix, cpiy, cpox, cpoy
            if(p.ictrl) {
                cpix = p.ictrl.x
                cpiy = p.ictrl.y
            }
            if(p.octrl) {
                cpox = p.octrl.x
                cpoy = p.octrl.y
            }
            NetContainer.addPlace(p.x, p.y, p.tokens, p.bars,
                                  [cpix, cpiy, cpox, cpoy],
                                  p.getPredecessor(), p.getSuccessor(),
                                  p.labelText, p.objectName)
        }

        for(var transition in tp.indexhandler.transitions) {
            var t = tp.indexhandler.transitions[transition]
            NetContainer.addTransition(t.x, t.y, t.getPredecessors(),
                                       t.getSuccessors(), t.state,
                                       t.labelText, t.objectName)
        }

        if(tp.routecollection.routes) {
            NetContainer.routes = tp.routecollection.routes
        }
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
        toContainer()
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
        var luuid = "_" + tp.indexhandler.generateLUUID()
        NetContainer.clear()
        IOHelper.load()

        var cc = []
        for(var i = NetContainer.places.length; i--;) {
            var p = NetContainer.places[i]
            var pid = p.objectname + luuid
            var place = tp.addRawPlace(p.x, p.y, p.tokens, p.bars, p.label, pid)
            cc[pid] = p.cp
        }

        for(var j = NetContainer.transitions.length; j--;) {
            var t = NetContainer.transitions[j]
            var transition = tp.addRawTransition(t.x, t.y, t.state,
                                                 t.label, t.objectname + luuid)

            var places1 = []
            for(var ti in t.inbound) {
                places1.push(tp.indexhandler.place(t.inbound[ti] + luuid))
            }
            tp.connectionhandler.addConnectionInbound(places1, transition)

            var places2 = []
            for(var to in t.outbound) {
                places2.push(tp.indexhandler.place(t.outbound[to] + luuid))
            }
            tp.connectionhandler.addConnectionOutbound(transition, places2)
        }

        for(var n in cc) { // for Place name in ControlCoords
            tp.indexhandler.place(n).setCtrl(cc[n][0], cc[n][1], cc[n][2], cc[n][3])
        }

        var routes = []
        for(var r in NetContainer.routes) {
            var route = []
            for(var rr in NetContainer.routes[r]) {
                route.push(NetContainer.routes[r][rr] + luuid)
            }
            routes.push(route)
        }
        tp.routecollection.setRoutes(routes)
    }
}
