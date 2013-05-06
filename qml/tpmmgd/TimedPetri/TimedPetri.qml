import QtQuick 2.0


Item {
    property Selector selector
    property IndexHandler indexhandler: ih
    property ConnectionHandler connectionhandler: ch
    property RouteCollection routecollection: rc
    property FocusHandler focushandler: fh
    id: timedpetri

    FocusHandler {
        id: fh
    }

    IndexHandler {
        id: ih
    }

    CanvasHandler {
        id: canvas
        indexhandler: ih
        anchors.fill: parent
    }

    ConnectionHandler {
        id: ch
        indexhandler: ih
        canvashandler: canvas
        net: net
    }

    RouteCollection {
        z: 3
        id: rc
        indexhandler: ih
        focushandler: fh
        width: 50
        height: rc.count * 30
        anchors.right: timedpetri.right
        anchors.bottom: timedpetri.bottom
    }

    function random(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function addCenteredPlace(x, y) {
        var place = Qt.createQmlObject("Place {}", net)
        place.objectName = 'place' + ih.generateUUID()
        place.focushandler = fh
        place.indexhandler = ih
        place.x = x - place.radius
        place.y = y - place.radius
        ih.addPlace(place)
        return place
    }

    function addRawPlace(x, y, tokens, bars, label, objectname) {
        var place = Qt.createQmlObject("Place {}", net)
        place.objectName = objectname
        place.focushandler = fh
        place.indexhandler = ih
        place.x = x
        place.y = y
        place.tokens = tokens
        place.bars = bars
        place.setLabel(label)
        ih.addPlace(place)
        return place
    }

    function addCenteredTransition(x, y) {
        var transition = Qt.createQmlObject("TransitionBar {}", net)
        transition.objectName = 'transition' + ih.generateUUID()
        transition.focushandler = fh
        transition.indexhandler = ih
        transition.x = x - transition.width / 2
        transition.y = y - transition.height / 2
        ih.addTransition(transition)
        return transition
    }

    function addRawTransition(x, y, state, label, objectname) {
        var transition = Qt.createQmlObject("TransitionBar {}", net)
        transition.objectName = objectname
        transition.focushandler = fh
        transition.indexhandler = ih
        transition.x = x
        transition.y = y
        transition.state = state
        transition.setLabel(label)
        ih.addTransition(transition)
        return transition
    }

    Item {
        id: net
        anchors.fill: parent
        z: 2
        focus: true
        Keys.onPressed: {
            if (event.key === Qt.Key_Space) {
                event.accepted = true;

                if(fh.count() > 1) {
                    ch.setConnections(fh.focused(), true)
                } else if (fh.count() > 0) {
                    for(var k in fh.focused()) {
                        fh.focused()[k].addToLabel(' ')
                    }
                }
            } else if (event.key === Qt.Key_Backspace) {
                event.accepted = true;

                if(fh.count() > 0) {
                    if(event.modifiers & Qt.ShiftModifier) {
                        ch.freeFromConnections(fh.focused())
                        rc.removeContaining(fh.focused())
                        ih.removeItems(fh.focused())
                        fh.clearFocused()
                    } else if (fh.count() > 1){
                        ch.setConnections(fh.focused(), false)
                    } else {
                        for(var i in fh.focused()) {
                            fh.focused()[i].backspaceLabel()
                        }
                    }
                }
            } else if (event.key === Qt.Key_R
                       && (event.modifiers & Qt.ControlModifier)) {
                event.accepted = true;

                if(rc.addRoute(fh.focused())) {
                    fh.clearFocused()
                }
            } else if (event.modifiers === Qt.NoModifier ||
                       event.modifiers === Qt.ShiftModifier ||
                       event.modifiers === Qt.AltModifier){
                if(/\S/ig.test(event.text)) {
                    event.accepted = true;
                    for(var j in fh.focused()) {
                        fh.focused()[j].addToLabel(event.text)
                    }
                }
            }
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                var s
                if(!selector) {
                    s = Qt.createQmlObject("Selector { z: 2 }", parent)
                    selector = s
                } else {
                    s = selector
                }

                s.x1 = mouse.x
                s.y1 = mouse.y
                s.update()
            }

            function updateSelector() {
                selector.x2 = mouseX
                selector.y2 = mouseY
                selector.update()

                for(var c = net.children.length; c--;) {
                    var child = net.children[c]
                    if(child.isPlace || child.isTransition) {
                        if(selector.containsPoint(child.collisionPoints[0][0],
                                                  child.collisionPoints[0][1])
                                || selector.containsPoint(child.collisionPoints[1][0],
                                                          child.collisionPoints[1][1])
                                || selector.containsPoint(child.collisionPoints[2][0],
                                                          child.collisionPoints[2][1])
                                || selector.containsPoint(child.collisionPoints[3][0],
                                                          child.collisionPoints[3][1])
                                || selector.containsPoint(child.centerX,
                                                          child.centerY)) {
                            fh.addFocusedPress(child, true)
                        } else {
                            fh.removeFocused(child)
                        }
                    }
                }
            }

            onMouseXChanged: updateSelector()
            onMouseYChanged: updateSelector()

            onReleased: { selector.destroy() }
        }
    }
}
