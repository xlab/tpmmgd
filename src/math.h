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
    QVariantList matrice(const QVariantList &data);
    QVariantList series(const QVariantList &data);
    QVariantList starSerie(const QVariantList& serie1);
    QVariantList starMatrice(const QVariantList& matrice1);
    QVariantList oplusSeries(const QVariantList& serie1, const QVariantList& serie2);
    QVariantList oplusMatrices(const QVariantList& matrice1, const QVariantList& matrice2);
    QVariantList otimesSeries(const QVariantList& serie1, const QVariantList& serie2);
    QVariantList otimesMatrices(const QVariantList& matrice1, const QVariantList& matrice2);

private:
    QVariantList gd_epsilon() {QVariantList l; l.append(infinity); l.append(_infinity); return l;}
    QVariantList gd_e() {QVariantList l; l.append(0); l.append(0); return l;}

    QString stringify(gd &m) const;
    QString stringify(const poly& p) const;
    QString stringify(serie& s) const;

    const poly initPoly(const QVariantList& data);
    const serie initSerie(const QVariantList& data);
    const smatrix initMatrice(const QVariantList& data);

    QVariantList listify(gd &monome) const;
    QVariantList listify(const poly& polynome) const;
    QVariantList listify(serie &series) const;
    QVariantList listify(smatrix &matrice) const;
};

#endif // MATH_H
