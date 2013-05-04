#ifndef NETCONTAINER_H
#define NETCONTAINER_H

#include <QObject>
#include <QQmlListProperty>
#include <QMetaProperty>
#include <QDebug>
#include <QDataStream>
#include "place.h"

class NetContainer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(const QQmlListProperty<Place> places READ places)

public:
    explicit NetContainer();
    friend QDataStream& operator<<(QDataStream&, const NetContainer&);
    friend QDataStream& operator>>(QDataStream&, NetContainer&);

public slots:
    void clear();
    int count() const;
    void addPlace(const int x, const int y, const int tokens, const int bars,
                  const QString &inbound, const QString &outbound,
                  const QString &label, const QString &objectname);

private:
    QList<Place *> m_places;
    const QQmlListProperty<Place> places();
};

#endif // NETCONTAINER_H
