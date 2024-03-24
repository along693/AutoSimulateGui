#include "editor_model.h"

#include <QSignalBlocker>
#include <QTextDocument>

EditorModel::EditorModel(QObject *parent)
        : QObject(parent), text_document_(nullptr), id_(0)
{}

QString EditorModel::text() const
{
    if (!text_document_) {
        return "";
    }

    return text_document_->toPlainText();
}

void EditorModel::setText(const QString &text)
{
    if (!text_document_) {
        return;
    }

    { // Only block signals in scope
        QSignalBlocker block_signals(this);
        text_document_->setPlainText(text);
    }

    emit textReplaced();
}

void EditorModel::setTextDocument(QTextDocument *text_document)
{
    text_document_ = text_document;
    if (!text_document_) {
        return;
    }

    connect(text_document_,
            &QTextDocument::contentsChanged,
            this,
            &EditorModel::textChanged);
}

int EditorModel::id() const
{
    return id_;
}

void EditorModel::setId(const int id)
{
    if (id_ == id) {
        return;
    }

    id_ = id;

    emit idChanged();
}
