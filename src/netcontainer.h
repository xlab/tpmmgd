#ifndef NETCONTAINER_H
#define NETCONTAINER_H

#include <QObject>
#include <QQmlListProperty>
#include <QMetaProperty>
#include <QDebug>
#include <QDataStream>
#include "place.h"
#include "transition.h"

class NetContainer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(const QQmlListProperty<Place>& places READ places)
    Q_PROPERTY(const QQmlListProperty<Transition>& transitions READ transitions)
    Q_PROPERTY(const QVariantList& routes READ routes WRITE setRoutes)

public:
    explicit NetContainer();
    friend QDataStream& operator<<(QDataStream&, const NetContainer&);
    friend QDataStream& operator>>(QDataStream&, NetContainer&);

public slots:
    void clear();
    void addPlace(const int x, const int y, const int tokens, const int bars,
                  const QList<int> &cp,
                  const QString &inbound, const QString &outbound,
                  const QString &label, const QString &objectname);
    void addTransition(const int x, const int y,
                       const QList<QString>& inbound, const QList<QString>& outbound,
                       const QString& state, const QString& label, const QString& objectname);

private:
    const QVariantList& routes() const;
    void setRoutes(const QVariantList& routes);
    QList<Place *> m_places;
    QList<Transition *> m_transitions;
    QVariantList m_routes;
    const QQmlListProperty<Place> places();
    const QQmlListProperty<Transition> transitions();
};

#endif // NETCONTAINER_H
