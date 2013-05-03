#include "iohelper.h"

IOHelper::IOHelper(const QApplication* app, NetContainer& container)
{
    this->app = app;
    this->container = &container;
}

IOHelper::~IOHelper()
{
    this->container->deleteLater();
}

void IOHelper::loadDialog() const
{
    QFileDialog d(app->activeWindow(), Qt::Dialog);
    d.setNameFilter("*.tpmmgd");
    d.setFileMode(QFileDialog::ExistingFile);
    d.setAcceptMode(QFileDialog::AcceptOpen);
    QObject::connect(&d, SIGNAL(fileSelected(const QString&)),
                     this, SLOT(loadDialogSuccess(const QString&)));
    d.exec();
}

void IOHelper::saveDialog() const
{
    QFileDialog d;
    d.setNameFilter("*.tpmmgd");
    d.setFileMode(QFileDialog::AnyFile);
    d.setAcceptMode(QFileDialog::AcceptSave);
    QObject::connect(&d, SIGNAL(fileSelected(QString)),
                     this, SLOT(saveDialogSuccess(QString)));
    d.exec();
}

void IOHelper::save() const
{
    QFile f(this->path());

    if(!f.open(QFile::WriteOnly)) {
        qDebug() << "Unable to open file for saving!";
        emit saveFail();
    } else {
        QDataStream ds(&f);
        ds.setVersion(QDataStream::Qt_5_0);
        ds << *container;
        emit saveSuccess();
    }
}

void IOHelper::load() const
{
    QFile f(this->path());

    if(!f.open(QFile::ReadOnly)) {
        qDebug() << "Unable to open file to load!";
        emit loadFail();
    } else {
        QDataStream ds(&f);
        ds.setVersion(QDataStream::Qt_5_0);
        ds >> *container;
        emit loadSuccess();
    }
}

void IOHelper::saveDialogSuccess(const QString& str)
{
    this->setPath(str);
    emit saveReady();
}

void IOHelper::loadDialogSuccess(const QString& str)
{
    this->setPath(str);
    emit loadReady();
}
