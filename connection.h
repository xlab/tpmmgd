#ifndef CONNECTION_H
#define CONNECTION_H

#include <QObject>

class Connection : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x)
    Q_PROPERTY(int y READ y)
    Q_PROPERTY(int tokens READ tokens)
    Q_PROPERTY(int bars READ bars)
    Q_PROPERTY(const QString& inbound READ inbound)
    Q_PROPERTY(const QString& outbound READ outbound)
    Q_PROPERTY(const QString& label READ label)
    Q_PROPERTY(const QString& objectname READ objectname)

public:
    Connection();
    Connection(const int x, const int y, const int tokens, const int bars,
                 const QString &inbound, const QString &outbound,
                 const QString &label, const QString &objectname);
    
private:
    int m_x, m_y, m_tokens, m_bars;
    QString m_inbound, m_outbound, m_label, m_objectname;
    int x() const { return m_x; }
    int y() const { return m_y; }
    int tokens() const { return m_tokens; }
    int bars() const { return m_bars; }
    const QString& inbound() const { return m_inbound; }
    const QString& outbound() const { return m_outbound; }
    const QString& label() const { return m_label; }
    const QString& objectname() const { return m_objectname; }
};

#endif // CONNECTION_H
