#include "navigation_model.h"

FileNavigationModel::FileNavigationModel(QObject *parent)
        : QObject(parent), selected_index_(-1)
{}

int FileNavigationModel::selectedIndex() const
{
    return selected_index_;
}

void FileNavigationModel::setSelectedIndex(int index)
{
    if (selected_index_ == index) {
        return;
    }

    selected_index_ = index;
    emit selectedIndexChanged();
}
