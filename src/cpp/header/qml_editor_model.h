#pragma once

#include "editor_model.h"
#include <QQuickTextDocument>


class QmlEditorModel : public EditorModel
{
Q_OBJECT
    Q_DISABLE_COPY_MOVE(QmlEditorModel)

    Q_PROPERTY(QQuickTextDocument *document READ document WRITE setDocument NOTIFY documentChanged)

public:
    explicit QmlEditorModel(QObject *parent = nullptr);

    QQuickTextDocument *document() const;
    void setDocument(QQuickTextDocument *document);

Q_SIGNALS:
    void documentChanged();

private:
    QTextDocument *textDocument() const;

    QQuickTextDocument *document_{nullptr};
};

