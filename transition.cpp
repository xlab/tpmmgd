#include "transition.h"

Transition::Transition()
{
}

void Transition::_setter(const int x, const int y, const QList<QString>& inbound,
             const QList<QString>& outbound, const QString& state,
             const QString& label, const QString& objectname)
{
    this->m_x = x;
    this->m_y = y;
    this->m_inbound = inbound;
    this->m_outbound = outbound;
    this->m_state = state;
    this->m_label = label;
    this->m_objectname = objectname;
}

Transition::Transition(const Transition& t2)
{
    _setter(t2.m_x, t2.m_y, t2.m_inbound, t2.m_outbound, t2.m_state, t2.m_label, t2.m_objectname);
}

Transition::Transition(const int x, const int y,
                       const QList<QString>& inbound, const QList<QString>& outbound,
                       const QString& state, const QString& label, const QString& objectname)
{
    _setter(x, y, inbound, outbound, state, label, objectname);
}

Transition& Transition::operator=(const Transition& t2)
{
    _setter(t2.m_x, t2.m_y, t2.m_inbound, t2.m_outbound, t2.m_state, t2.m_label, t2.m_objectname);
    return *this;
}

QDataStream& operator<<(QDataStream& ds, const Transition& t)
{
    ds << t.m_x << t.m_y << t.m_inbound <<
          t.m_outbound << t.m_state << t.m_label << t.m_objectname;
    return ds;
}

QDataStream& operator>>(QDataStream& ds, Transition& t)
{
    ds >> t.m_x >> t.m_y >> t.m_inbound >>
          t.m_outbound >> t.m_state >> t.m_label >> t.m_objectname;
    return ds;
}
