#include "math.h"
#include "vars.h"

Math::Math()
{
}

void Math::setPoly(const QVariantList& data) {
    poly p;
    gd monome;

    foreach(const QVariant& v1, data) {
        QList<QVariant> m = v1.toList();
        p.add(monome.init(m.at(0).toInt(), m.at(1).toInt()));
    }
    this->m_poly = p;
}

QString Math::printSerie(const QVariantList& data)
{
    setPoly(data);
    serie s(m_poly);
    return stringify(s);
}

QVariantList Math::printMatrice(const QVariantList& data) {
    QVariantList list;
    bool zero = true;

    // iterate rows
    for(int i = 0; i < data.length(); ++i) {
        QVariantList row = data.at(i).toList();
        QVariantList srow;

        // iterate polynomes in row
        for(int j = 0; j < row.length(); ++j) {
            QVariantList polynome = row.at(j).toList();
            setPoly(polynome);

            if(!(m_poly == poly(epsilon))) {
                zero = false;
            }

            serie s1(m_poly);
            srow.append(stringify(s1));
        }

        // make matrice
        QVariant var(srow);
        list.append(var);
    }

    if(zero) {
        list.clear();
        list.append("eps");
    }

    return list;
}

QString Math::stringify(gd& m) const {
    if(m == e) {
        return "e";
    } else if(m == epsilon) {
        return "eps";
    } else {
        return QString("g^%1d^%2").arg(m.getg()).arg(m.getd());
    }
}

QString Math::stringify(const poly& p) const {
    QString str;
    for(unsigned int i = 0; i < p.getn(); ++i) {
        str += stringify(p.getpol(i));
        if(i < p.getn() - 1) {
            str += " + ";
        }
    }
    return str;
}

QString Math::stringify(serie& s) const {
    if(s == eps) {
        return "eps";
    }

    QString str;
    if(!(s.getp() == poly(epsilon))) {
        str += stringify(s.getp()) + " + ";
    }

    if(s.getr() == e) {
        str += stringify(s.getq());
    } else {
        if(!(s.getq() == poly(e))) {
            str += "(" + stringify(s.getq()) + ")";
        }
        str += "[" + stringify(s.getr()) + "]*";
    }
    return str;
}
