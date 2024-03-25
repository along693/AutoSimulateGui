#pragma once

#include <QObject>
#include <QString>
#include "abstract_editor_model.h"

class AbstractEditorModel;

class EditorController : public QObject
{
Q_OBJECT
    Q_DISABLE_COPY_MOVE(EditorController)

public:
    explicit EditorController(QObject *parent = nullptr);

    void setModel(AbstractEditorModel &model);

    QString text() const;
    void setText(const QString &text);

    int id() const;
    void setId(int id);

Q_SIGNALS:
    void textChanged();

private:
    AbstractEditorModel *model_{nullptr};
    QMetaObject::Connection text_changed_connection_;
};

