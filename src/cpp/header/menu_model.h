#pragma once

#include <QObject>
#include <QString>
#include <QPointer>
#include <QtCore/qglobal.h>

class DocumentHandler;

class MenuModel : public QObject
{
Q_OBJECT
    Q_DISABLE_COPY_MOVE(MenuModel)

    Q_PROPERTY(QString title READ title NOTIFY titleChanged)
    Q_PROPERTY(bool isNewFile READ isNewFile NOTIFY isNewFileChanged)

public:
    explicit MenuModel(QObject *parent = nullptr);

    void setDocument(DocumentHandler &document_handler);

    QString title() const;
    bool isNewFile() const;

Q_SIGNALS:
    void titleChanged();
    void isNewFileChanged();

private:
    QPointer<DocumentHandler> document_handler_;
};
