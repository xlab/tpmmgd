import QtQuick 2.0


Item {
    property Selector selector
    id: timedpetri

    FocusHandler {
        id: fh
    }

    IndexHandler {
        id: ih
    }

    ConnectionHandler {
        id: ch
        indexhandler: ih
        net: net
    }

    function random(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function addPlace(x, y) {
        var place = Qt.createQmlObject("Place {}", net)
        place.objectName = 'place' + ih.generateUUID()
        place.focushandler = fh
        place.indexhandler = ih
        place.x = x - place.radius
        place.y = y - place.radius

        ih.addPlace(place)
        return place
    }

    function addTransition(x, y) {
        var transition = Qt.createQmlObject("TransitionBar {}", net)
        transition.objectName = 'transition' + ih.generateUUID()
        transition.focushandler = fh
        transition.indexhandler = ih
        transition.x = x - transition.width / 2
        transition.y = y - transition.height / 2

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
                    console.log("Connecting focused");
                    ch.addConnections(fh.focused())
                    fh.shiftAll(1,1) // :D
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

                // Detect collision with center of each Place
                for(var c =net.children.length; c--;) {
                    var child = net.children[c]
                    if(child.isPlace || child.isTransition) {
                        if(selector.containsPoint(child.collisionPoints[0][0],
                                                  child.collisionPoints[0][1])
                                || selector.containsPoint(child.collisionPoints[1][0],
                                                          child.collisionPoints[1][1])
                                || selector.containsPoint(child.collisionPoints[2][0],
                                                          child.collisionPoints[2][1])
                                || selector.containsPoint(child.collisionPoints[3][0],
                                                          child.collisionPoints[3][1])) {
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

    Rectangle {
        z: 2
        x: 100
        y: 100
        width: 10
        height: 10
        color: 'red'
        MouseArea {
            anchors.fill: parent
            onPressed: {
                var place = addPlace(parent.x + mouse.x, parent.y + mouse.y)
                drag.target = place
            }
        }
    }

    Rectangle {
        z: 2
        x: 100
        y: 120
        width: 10
        height: 10
        color: 'green'
        MouseArea {
            anchors.fill: parent
            onPressed: {
                var transition = addTransition(parent.x + mouse.x, parent.y + mouse.y)
                drag.target = transition
            }
        }
    }
}
