#ifndef PLACE_H
#define PLACE_H

#include <QObject>

class Place : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x)
    Q_PROPERTY(int y READ y)
    Q_PROPERTY(int tokens READ tokens)
    Q_PROPERTY(int bars READ bars)
    Q_PROPERTY(const QString& inbound READ inbound)
    Q_PROPERTY(const QString& outbound READ outbound)

public:
    Place();
    Place(const int x, const int y, const int tokens, const int bars,
                   const QString& inbound, const QString& outbound);
    
private:
    int m_x, m_y, m_tokens, m_bars;
    QString m_inbound, m_outbound;
    int x() const { return m_x; }
    int y() const { return m_y; }
    int tokens() const { return m_tokens; }
    int bars() const { return m_bars; }
    const QString& inbound() const { return m_inbound; }
    const QString& outbound() const { return m_outbound; }
};

#endif // PLACE_H
