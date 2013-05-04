#include "place.h"
#include <QDebug>

Place::Place()
{
}

Place::Place(const Place &p2)
{
    this->m_x = p2.m_x;
    this->m_y = p2.m_y;
    this->m_tokens = p2.m_tokens;
    this->m_bars = p2.m_bars;
    this->m_inbound = p2.m_inbound;
    this->m_outbound = p2.m_outbound;
    this->m_label = p2.m_label;
    this->m_objectname = p2.m_objectname;
}

Place::Place(const int x, const int y, const int tokens, const int bars,
             const QString &inbound, const QString &outbound,
             const QString &label, const QString &objectname)
{
    this->m_x = x;
    this->m_y = y;
    this->m_tokens = tokens;
    this->m_bars = bars;
    this->m_inbound = inbound;
    this->m_outbound = outbound;
    this->m_label = label;
    this->m_objectname = objectname;
}

Place& Place::operator=(const Place &p2)
{
    this->m_x = p2.m_x;
    this->m_y = p2.m_y;
    this->m_tokens = p2.m_tokens;
    this->m_bars = p2.m_bars;
    this->m_inbound = p2.m_inbound;
    this->m_outbound = p2.m_outbound;
    this->m_label = p2.m_label;
    this->m_objectname = p2.m_objectname;

    return *this;
}

QDataStream& operator<<(QDataStream& ds, const Place& place)
{
    ds << place.m_x << place.m_y << place.m_tokens << place.m_bars
       << place.m_inbound << place.m_outbound << place.m_label << place.m_objectname;
    return ds;
}

QDataStream& operator>>(QDataStream& ds, Place& place)
{
    ds >> place.m_x >> place.m_y >> place.m_tokens >> place.m_bars
       >> place.m_inbound >> place.m_outbound >> place.m_label >> place.m_objectname;
    return ds;
}
