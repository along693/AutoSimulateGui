#include "qml_editor_model.h"

#include <QQuickTextDocument>

QmlEditorModel::QmlEditorModel(QObject *parent)
        : EditorModel{parent}
{}

QQuickTextDocument *QmlEditorModel::document() const
{
    return document_;
}

void QmlEditorModel::setDocument(QQuickTextDocument *document)
{
    setTextDocument(nullptr);
    document_ = document;

    if (!document_) {
        return;
    }

    setTextDocument(document_->textDocument());
}
