TEMPLATE = app
TARGET = tpmmgd

# QML targets
tpmmgd.source = ../qml/tpmmgd
tpmmgd.target = qml

# JS dependencies for the Editor
mathjax.source = ../lib/mathjax/unpacked/
mathjax.target = qml/tpmmgd/Editor/mathjax
ace.source = ../lib/ace/src-noconflict/
ace.target = qml/tpmmgd/Editor/ace
require.source = ../lib/require/
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
include(../qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += \
    ../qml/tpmmgd/Editor/math.html \ 
    ../qml/tpmmgd/Editor/latex.html

# Linkage with libminmaxgd
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../lib/minmaxgd/src/release/ -lminmaxgd
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../lib/minmaxgd/src/debug/ -lminmaxgd
else:unix: LIBS += -L$$OUT_PWD/../lib/minmaxgd/src/ -lminmaxgd

INCLUDEPATH += $$PWD/../lib/minmaxgd/src
DEPENDPATH += $$PWD/../lib/minmaxgd/src

win32:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../lib/minmaxgd/src/release/minmaxgd.lib
else:win32:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../lib/minmaxgd/src/debug/minmaxgd.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../lib/minmaxgd/src/libminmaxgd.a
