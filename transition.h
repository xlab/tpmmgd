#ifndef TRANSITION_H
#define TRANSITION_H

#include <QObject>
#include <QDataStream>

class Transition : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int x READ x)
    Q_PROPERTY(int y READ y)
    Q_PROPERTY(const QList<QString>& inbound READ inbound)
    Q_PROPERTY(const QList<QString>& outbound READ outbound)
    Q_PROPERTY(const QString& state READ state)
    Q_PROPERTY(const QString& label READ label)
    Q_PROPERTY(const QString& objectname READ objectname)

public:
    Transition();
    Transition(const Transition& t2);
    Transition(const int x, const int y, const QList<QString>& inbound,
               const QList<QString>& outbound, const QString& state,
               const QString& label, const QString& objectname);
    Transition& operator=(const Transition& t2);

private:
    int m_x, m_y;
    QList<QString> m_inbound, m_outbound;
    QString m_state, m_label, m_objectname;

    friend QDataStream& operator<<(QDataStream&, const Transition&);
    friend QDataStream& operator>>(QDataStream&, Transition&);

    int x() const { return m_x; }
    int y() const { return m_y; }
    const QList<QString>& inbound() const { return m_inbound; }
    const QList<QString>& outbound() const { return m_outbound; }
    const QString& state() const { return m_state; }
    const QString& label() const { return m_label; }
    const QString& objectname() const { return m_objectname; }
};

#endif // TRANSITION_H
