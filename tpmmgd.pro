# Add more folders to ship with the application, here
folder_01.source = qml/tpmmgd
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

SOURCES += src/main.cpp \
    src/iohelper.cpp \
    src/netcontainer.cpp \
    src/place.cpp \
    src/transition.cpp

HEADERS += \
    src/iohelper.h \
    src/netcontainer.h \
    src/place.h \
    src/transition.h

QT += widgets

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()


