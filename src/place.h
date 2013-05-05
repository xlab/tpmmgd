#ifndef PLACE_H
#define PLACE_H

#include <QObject>
#include <QDataStream>

class Place : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x)
    Q_PROPERTY(int y READ y)
    Q_PROPERTY(int tokens READ tokens)
    Q_PROPERTY(int bars READ bars)
    Q_PROPERTY(const QList<int>& cp READ cp)
    Q_PROPERTY(const QString& inbound READ inbound)
    Q_PROPERTY(const QString& outbound READ outbound)
    Q_PROPERTY(const QString& label READ label)
    Q_PROPERTY(const QString& objectname READ objectname)

public:
    Place();
    Place(const Place& p2);
    Place(const int x, const int y,
          const int tokens, const int bars,
          const QList<int>& cp,
          const QString &inbound, const QString &outbound,
          const QString &label, const QString &objectname);
    Place& operator=(const Place& p2);
    
private:
    int m_x, m_y, m_cpx, m_cpy, m_tokens, m_bars;
    QString m_inbound, m_outbound, m_label, m_objectname;
    QList<int> m_cp;

    friend QDataStream& operator<<(QDataStream&, const Place&);
    friend QDataStream& operator>>(QDataStream&, Place&);

    int x() const { return m_x; }
    int y() const { return m_y; }
    int tokens() const { return m_tokens; }
    int bars() const { return m_bars; }
    const QList<int>& cp() const { return m_cp; }
    const QString& inbound() const { return m_inbound; }
    const QString& outbound() const { return m_outbound; }
    const QString& label() const { return m_label; }
    const QString& objectname() const { return m_objectname; }

    void _setter(const int x, const int y,
                 const int tokens, const int bars,
                 const QList<int>& cp,
                 const QString &inbound, const QString &outbound,
                 const QString &label, const QString &objectname);
};

#endif // PLACE_H
