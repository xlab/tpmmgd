# QML targets
tpmmgd.source = qml/tpmmgd
tpmmgd.target = qml

# JS dependencies for the Editor
mathjax.source = lib/mathjax/unpacked/
mathjax.target = qml/tpmmgd/Editor/mathjax
ace.source = lib/ace/lib/ace/
ace.target = qml/tpmmgd/Editor/ace
require.source = lib/require/
require.target = qml/tpmmgd/Editor

# Go!
DEPLOYMENTFOLDERS = tpmmgd mathjax ace require

SOURCES += main.cpp \
    iohelper.cpp \
    netcontainer.cpp \
    place.cpp \
    transition.cpp

HEADERS += \
    iohelper.h \
    netcontainer.h \
    place.h \
    transition.h

QT += widgets

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    qml/tpmmgd/Editor/math.html


