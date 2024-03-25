#include "navigation_controller.h"
#include "navigation_model.h"

FileNavigationController::FileNavigationController(QObject *parent)
        : QObject(parent), model_(nullptr)
{}

void FileNavigationController::setModel(FileNavigationModel &model)
{
    model_ = &model;
}

int FileNavigationController::selectedIndex() const
{
    if (!model_) {
        return -1;
    }

    return model_->selectedIndex();
}

void FileNavigationController::setSelectedIndex(int index)
{
    if (!model_) {
        return;
    }

    model_->setSelectedIndex(index);
}
