#include "netcontainer.h"

NetContainer::NetContainer()
{
}

void NetContainer::clear()
{
    this->m_places.clear();
    this->m_transitions.clear();
}

void NetContainer::addPlace(const int x, const int y, const int tokens, const int bars,
                            const QString& inbound, const QString& outbound,
                            const QString &label, const QString& objectname)
{
    Place *p = new Place(x, y, tokens, bars, inbound, outbound, label, objectname);
    this->m_places.append(p);
}

void NetContainer::addTransition(const int x, const int y,
                                 const QList<QString>& inbound, const QList<QString>& outbound,
                                 const QString& state, const QString& label, const QString& objectname)
{
    Transition *t = new Transition(x, y, inbound, outbound, state, label, objectname);
    this->m_transitions.append(t);
}

const QQmlListProperty<Place> NetContainer::places()
{
    return QQmlListProperty<Place>(this, m_places);
}

const QQmlListProperty<Transition> NetContainer::transitions()
{
    return QQmlListProperty<Transition>(this, m_transitions);
}

QDataStream& operator<<(QDataStream& ds, const NetContainer& net)
{
    QList<Place> list_places;
    QList<Transition> list_transitions;

    foreach(const Place* p, net.m_places) {
        list_places.append(*p);
    }
    foreach(const Transition* t, net.m_transitions) {
        list_transitions.append(*t);
    }

    ds << list_places << list_transitions;
    return ds;
}

QDataStream& operator>>(QDataStream& ds, NetContainer& net)
{
    QList<Place> list_places;
    QList<Transition> list_transitions;
    net.m_places.clear();
    net.m_transitions.clear();

    ds >> list_places >> list_transitions;

    foreach(const Place& p, list_places) {
        Place *ptr = new Place(p);
        net.m_places.append(ptr);
    }
    foreach(const Transition& t, list_transitions) {
        Transition *ptr = new Transition(t);
        net.m_transitions.append(ptr);
    }

    return ds;
}

