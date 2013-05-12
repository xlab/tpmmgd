#include <QApplication>
#include <QQmlContext>
#include <QQmlComponent>
#include "qtquick2applicationviewer.h"
#include "iohelper.h"
#include "netcontainer.h"
#include "place.h"
#include "math.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    NetContainer netContainer;
    IOHelper ioHelper(&app, netContainer);
    Math math;

    qmlRegisterType<Place>("Net", 1,0, "Place");
    qmlRegisterType<Transition>("Net", 1,0, "Transition");

    QtQuick2ApplicationViewer view;
    view.rootContext()->setContextProperty("IOHelper", &ioHelper);
    view.rootContext()->setContextProperty("NetContainer", &netContainer);
    view.rootContext()->setContextProperty("MathEvaluator", &math);
    view.setMainQmlFile(QStringLiteral("qml/tpmmgd/main.qml"));
    view.setMinimumSize(QSize(700, 300));
    view.showExpanded();

    return app.exec();
}
