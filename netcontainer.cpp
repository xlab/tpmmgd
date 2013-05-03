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
                            const QString& inbound, const QString& outbound)
{
    QList<QVariant> list;
    list << x << y << tokens << bars << inbound << outbound;
    this->m_places.append(list);
}

const QQmlListProperty<Place> NetContainer::places()
{
    QList<Place*> list;
    foreach(PlaceContainer p, m_places) {
        Place* place = new Place(p.at(0).toInt(), p.at(1).toInt(),
                                 p.at(2).toInt(), p.at(3).toInt(),
                                 p.at(4).toString(), p.at(5).toString());
        list.append(place);
    }

    return QQmlListProperty<Place>(this, list);
}

QDataStream& operator<<(QDataStream& ds, const NetContainer& net)
{
    ds << net.m_places;
    return ds;
}

QDataStream& operator>>(QDataStream& ds, NetContainer& net)
{
    ds >> net.m_places;
    return ds;
}

