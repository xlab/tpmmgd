#include "connection.h"

Connection::Connection()
{

}

Connection::Connection(const int x, const int y, const int tokens, const int bars,
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
