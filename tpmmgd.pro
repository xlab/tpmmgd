# Add more folders to ship with the application, here
timedpetri.source = qml/tpmmgd/TimedPetri
timedpetri.target = qml
editor.source = qml/tpmmgd/Editor
editor.target = qml

mathjax.source = lib/mathjax/unpacked
mathjax.target = lib/mathjax
ace.source = lib/ace/lib/ace
ace.target = lib/ace
require.source = lib/require
require.target = lib
DEPLOYMENTFOLDERS = timedpetri mathjax mathjax ace require

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


