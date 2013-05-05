#ifndef IOHELPER_H
#define IOHELPER_H

#include <QObject>
#include <QFileDialog>
#include <QApplication>
#include <QFile>
#include <QDebug>
#include "netcontainer.h"

#define FILE_FORMAT "Timed Petri MMGD (*.tpmmgd)"

class IOHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged)

public:
    explicit IOHelper(const QApplication* app, NetContainer& container);
    ~IOHelper();

    void setPath(const QString& p) {
        if(p != m_path) {
            m_path = p;
            emit pathChanged();
        }
    }

    QString path() const {
        return m_path;
    }

signals:
    void pathChanged() const;
    void screenshotCompleted() const;
    void saveSuccess() const;
    void loadSuccess() const;
    void saveFail() const;
    void loadFail() const;
    void saveReady() const;
    void loadReady() const;

public slots:
    void loadDialog() const;
    void saveDialog() const;
    void save() const;
    void load() const;

private slots:
    void saveDialogSuccess(const QString&);
    void loadDialogSuccess(const QString&);

private:
    const QApplication* app;
    NetContainer* container;
    QString m_path;
};

#endif // IOHELPER_H
