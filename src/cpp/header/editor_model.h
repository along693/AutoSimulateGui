#pragma once

#include <QObject>
#include <QString>

class QTextDocument;

class EditorModel : public QObject
{
Q_OBJECT
    Q_DISABLE_COPY_MOVE(EditorModel)

    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textReplaced)
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged)

public:
    explicit EditorModel(QObject *parent = nullptr);

    virtual QString text() const = 0;
    virtual void setText(const QString &text) = 0;

    int id() const;
    void setId(int id);

    void setTextDocument(QTextDocument *text_document);

Q_SIGNALS:
    //! Used when the a minor change has been made in the text
    void textChanged();

    //! Used when setText is called (and therefore replaced).
    void textReplaced();
    void idChanged();

private:
    int id_{0};
    QTextDocument *text_document_{nullptr};
};
