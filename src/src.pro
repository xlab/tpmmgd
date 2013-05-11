TEMPLATE = app

LIBS += -L../lib/minmaxgd/src -lminmaxgd
INCLUDEPATH += ../lib/minmaxgd/src

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
