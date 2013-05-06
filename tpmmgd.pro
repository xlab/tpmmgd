# Add more folders to ship with the application, here
folder_01.source = qml/tpmmgd
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

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


