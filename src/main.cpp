#include <QApplication>
#include <QQmlContext>
#include <QQmlComponent>
#include "qtquick2applicationviewer.h"
#include "iohelper.h"
#include "netcontainer.h"
#include "place.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    NetContainer netContainer;
    IOHelper ioHelper(&app, netContainer);

    qmlRegisterType<Place>("Net", 1,0, "Place");
    qmlRegisterType<Transition>("Net", 1,0, "Transition");

    QtQuick2ApplicationViewer view;
    view.rootContext()->setContextProperty("IOHelper", &ioHelper);
    view.rootContext()->setContextProperty("NetContainer", &netContainer);
    view.setMainQmlFile(QStringLiteral("qml/tpmmgd/main.qml"));

    view.showExpanded();

    return app.exec();
}
