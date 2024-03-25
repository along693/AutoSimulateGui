#include "editor_controller.h"
#include "abstract_editor_model.h"

EditorController::EditorController(QObject *parent)
        : QObject{parent}
{}

void EditorController::setModel(AbstractEditorModel &model)
{
    disconnect(text_changed_connection_);
    model_ = &model;
    text_changed_connection_ = connect(model_, &AbstractEditorModel::textChanged, this, &EditorController::textChanged);
}

QString EditorController::text() const
{
    return model_ ? model_->text() : QString();
}

void EditorController::setText(const QString &text)
{
    if (model_)
        model_->setText(text);
}

int EditorController::id() const
{
    return model_ ? model_->id() : 0;
}

void EditorController::setId(int id)
{
    if (model_)
        model_->setId(id);
}
