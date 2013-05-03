#include "place.h"

Place::Place()
{

}

Place::Place(const int x, const int y, const int tokens, const int bars,
             const QString &inbound, const QString &outbound)
{
    this->m_x = x;
    this->m_y = y;
    this->m_tokens = tokens;
    this->m_bars = bars;
    this->m_inbound = inbound;
    this->m_outbound = outbound;
}
