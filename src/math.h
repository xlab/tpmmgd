#ifndef MATH_H
#define MATH_H

#include <QObject>
#include <QDebug>
#include "gd.h"
#include "poly.h"
#include "serie.h"
#include "smatrix.h"
#include <sstream>

class Math : public QObject
{
    Q_PROPERTY(QVariantList gd_epsilon READ gd_epsilon)
    Q_PROPERTY(QVariantList gd_e READ gd_e)
    Q_OBJECT
public:
    explicit Math();

public slots:
    QString printSerie(const QVariantList& data);
    QVariantList printMatrice(const QVariantList &data);
    // QString& stringify(gd& monome);
    // QString& stringify(poly& polynome);

private:
    QVariantList gd_epsilon() {QVariantList l; l.append(infinity); l.append(_infinity); return l;}
    QVariantList gd_e() {QVariantList l; l.append(0); l.append(0); return l;}
    void setSerie(poly &polynome);
    void setPoly(const QVariantList& data);
    QString stringify(gd &m) const;
    QString stringify(const poly& p) const;
    QString stringify(serie& s) const;

    gd m_gd;
    poly m_poly;
    serie m_serie;
};

#endif // MATH_H
