#include "math.h"
#include "vars.h"

Math::Math()
{
}

QString Math::printSerie(const QVariantList& data)
{
    serie s = initSerie(data);
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
            QVariantList series = row.at(j).toList();
            serie s = initSerie(series);

            if(!(s == eps)) {
                zero = false;
            }

            srow.append(stringify(s));
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

const poly Math::initPoly(const QVariantList& data) {
    poly p;
    gd monome;

    foreach(const QVariant& element, data) {
        QVariantList m = element.toList();
        if(m.length() != 2 ||
                (m.at(0).type() == QVariant::List) ||
                (m.at(1).type() == QVariant::List)) {
            poly EPS(infinity, _infinity);
            return EPS;
        }

        p.add(monome.init(m.at(0).toLongLong(), m.at(1).toLongLong()));
    }

    return p;
}

const serie Math::initSerie(const QVariantList& data) {
    bool data_is_serie = false;
    if(data.length() == 3) {
        QVariantList pl = data.at(0).toList();
        QVariantList ql = data.at(1).toList();
        QVariantList rl = data.at(2).toList();

        if((pl.length() > 0 && pl.at(0).type() == QVariant::List)
                || (ql.length() > 0 && ql.at(0).type() == QVariant::List))
        {
            if(rl.length() == 2 &&
                    (rl.at(0).type() == QVariant::LongLong ||
                     rl.at(0).type() == QVariant::Int) &&
                    (rl.at(1).type() == QVariant::LongLong ||
                     rl.at(1).type() == QVariant::Int))
            {
                data_is_serie = true;
            }
        }
    }

    if(data_is_serie) {
        serie s;
        poly p, q;
        gd r;

        QVariantList m = data.at(2).toList();
        p = initPoly(data.at(0).toList());
        q = initPoly(data.at(1).toList());
        r = gd(m.at(0).toLongLong(), m.at(1).toLongLong());
        s = serie(p, q, r);

        return s;
    } else {
        poly p = initPoly(data);
        serie result(epsilon, p, e);
        return result;
    }
}

const smatrix Math::initMatrice(const QVariantList& data){
    int rows = data.length();

    if(rows < 1) {
        smatrix EPS(1,1);
        return EPS;
    }

    int columns = 0;
    for(int i = 0; i < data.length(); ++i) {
        int len = data.at(i).toList().length();
        if(len > columns) {
            columns = len;
        }
    }

    smatrix A(rows, columns);

    int i = 0;
    int j = 0;
    foreach(const QVariant& element, data) {
        j = 0;
        QVariantList row = element.toList();
        foreach(const QVariant& series, row) {
            A(i, j) = initSerie(series.toList());
            ++j;
        }
        ++i;
    }

    return A;
}

QVariantList Math::listify(gd& monome) const {
    QVariantList list;
    list.append(QVariant((qlonglong) (monome.getg())));
    list.append(QVariant((qlonglong) (monome.getd())));
    return list;
}

QVariantList Math::listify(const poly& polynome) const {
    QVariantList list;

    for(unsigned int i = 0; i < polynome.getn(); ++i) {
        QVariant m = listify(polynome.getpol(i));
        list.append(m);
    }

    return list;
}

QVariantList Math::listify(serie& series) const {
    QVariantList list;

    QVariant p = listify(series.getp());
    QVariant q = listify(series.getq());
    QVariant r = listify(series.getr());
    list.append(p);
    list.append(q);
    list.append(r);

    return list;
}

QVariantList Math::listify(smatrix& matrice) const {
    QVariantList list;

    for(int i = 0; i < matrice.getrow(); ++i) {
        QVariantList row;

        for(int j = 0; j < matrice.getcol(); ++j) {
            row.append(QVariant(listify(matrice(i, j))));
        }

        list.append(QVariant(row));
    }

    return list;
}

QVariantList Math::matrice(const QVariantList &data) {
    smatrix sm = initMatrice(data);
    return listify(sm);
}

QVariantList Math::series(const QVariantList &data) {
    serie s = initSerie(data);
    return listify(s);
}

QVariantList Math::starSerie(const QVariantList& serie1) {
    serie s = initSerie(serie1);
    serie s2 = star(s);
    return listify(s2);
}

QVariantList Math::starMatrice(const QVariantList& matrice1) {
    smatrix sm = initMatrice(matrice1);
    smatrix sm2 = star(sm);
    return listify(sm2);
}

QVariantList Math::oplusSeries(const QVariantList& serie1, const QVariantList& serie2) {
    serie s1 = initSerie(serie1);
    serie s2 = initSerie(serie2);
    serie result = oplus(s1, s2);
    return listify(result);
}

QVariantList Math::oplusMatrices(const QVariantList& matrice1, const QVariantList& matrice2) {
    smatrix sm1 = initMatrice(matrice1);
    smatrix sm2 = initMatrice(matrice2);
    smatrix result = oplus(sm1, sm2);
    return listify(result);
}

QVariantList Math::otimesSeries(const QVariantList& serie1, const QVariantList& serie2) {
    serie s1 = initSerie(serie1);
    serie s2 = initSerie(serie2);
    serie result = otimes(s1, s2);
    return listify(result);
}

QVariantList Math::otimesMatrices(const QVariantList& matrice1, const QVariantList& matrice2){
    smatrix sm1 = initMatrice(matrice1);
    smatrix sm2 = initMatrice(matrice2);
    smatrix result = otimes(sm1, sm2);
    return listify(result);
}

QString Math::stringify(gd& m) const {
    if(m == e) {
        return "e";
    } else if(m == epsilon) {
        return "eps";
    } else {
        return QString("g^{%1}d^{%2}").arg(m.getg()).arg(m.getd());
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
            if(s.getq().getn() < 2) {
                str += stringify(s.getq());
            } else {
                str += "(" + stringify(s.getq()) + ")";
            }
        }

        if(!(s.getq().getn() == 1 &&
             s.getq().getpol(0) == gd(0, infinity) &&
             s.getr() == gd(0, infinity))) {
            str += "[" + stringify(s.getr()) + "]*";
        }
    }
    return str;
}
