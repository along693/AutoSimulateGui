#pragma once

#include "abstract_editor_model.h"
#include <QString>

class QTextDocument;

class EditorModel : public AbstractEditorModel
{
Q_OBJECT
    Q_DISABLE_COPY_MOVE(EditorModel)

public:
    explicit EditorModel(QObject *parent = nullptr);

    QString text() const override;
    void setText(const QString &text) override;

    void setTextDocument(QTextDocument *text_document);

private:
    QTextDocument *text_document_{nullptr};
};

