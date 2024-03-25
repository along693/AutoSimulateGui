#include "menu_controller.h"
#include "menu_model.h"

MenuController::MenuController(QObject *parent)
        : QObject{parent}
{}

void MenuController::setModel(MenuModel &model)
{
    model_ = &model;
}

void MenuController::setDocument(DocumentHandler &document_handler)
{
    if (!model_) {
        return;
    }

    model_->setDocument(document_handler);
}
