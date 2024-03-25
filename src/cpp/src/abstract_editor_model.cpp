#include "abstract_editor_model.h"

AbstractEditorModel::AbstractEditorModel(QObject *parent)
        : QObject(parent)
{}

int AbstractEditorModel::id() const
{
    return id_;
}

void AbstractEditorModel::setId(int id)
{
    if (id_ == id) {
        return;
    }

    id_ = id;

    emit idChanged();
}
