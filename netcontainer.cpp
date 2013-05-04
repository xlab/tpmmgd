#include "netcontainer.h"

NetContainer::NetContainer()
{
}

void NetContainer::clear()
{
    this->m_places.clear();
}

int NetContainer::count() const
{
    return this->m_places.count();
}

void NetContainer::addPlace(const int x, const int y, const int tokens, const int bars,
                            const QString& inbound, const QString& outbound,
                            const QString &label, const QString& objectname)
{
    Place *p = new Place(x, y, tokens, bars, inbound, outbound, label, objectname);
    this->m_places.append(p);
}

const QQmlListProperty<Place> NetContainer::places()
{
    return QQmlListProperty<Place>(this, m_places);
}

QDataStream& operator<<(QDataStream& ds, const NetContainer& net)
{
    QList<Place> list;
    foreach(const Place* p, net.m_places) {
        list.append(*p);
    }

    ds << list;
    return ds;
}

QDataStream& operator>>(QDataStream& ds, NetContainer& net)
{
    QList<Place> list;
    ds >> list;
    net.m_places.clear();
    foreach(const Place& p, list) {
        Place *ptr = new Place(p);
        net.m_places.append(ptr);
    }

    return ds;
}

