#pragma once

#include <QObject>
#include <QString>
#include <QTextDocument>


class AbstractEditorModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textReplaced)
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)

public:
    explicit AbstractEditorModel(QObject *parent = nullptr);

    virtual QString text() const = 0;
    virtual void setText(const QString &text) = 0;

    int id() const;
    void setId(int id);

Q_SIGNALS:
    void textChanged();
    void textReplaced();
    void idChanged();

private:
    int id_ = 0;
};

