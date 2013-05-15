#ifndef CLIPBOARDHELPER_H
#define CLIPBOARDHELPER_H

#include <QApplication>
#include <QClipboard>
#include <QObject>

class ClipboardHelper : public QObject
{
    Q_OBJECT
public:
    explicit ClipboardHelper(QObject *parent = 0) : QObject(parent) {
        clipboard = QApplication::clipboard();
    }

    Q_INVOKABLE void setText(QString text){
        clipboard->setText(text, QClipboard::Clipboard);
        clipboard->setText(text, QClipboard::Selection);
    }

    Q_INVOKABLE QString getText(){
       return clipboard->text();
    }

private:
    QClipboard *clipboard;
};

#endif // CLIPBOARDHELPER_H
