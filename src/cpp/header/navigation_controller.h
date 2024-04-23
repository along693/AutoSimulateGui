#pragma once

#include <QObject>

class FileNavigationModel;
class FileNavigationController : public QObject
{
Q_OBJECT
    Q_DISABLE_COPY_MOVE(FileNavigationController)

public:
    explicit FileNavigationController(QObject *parent = nullptr);

    void setModel(FileNavigationModel &model);

    int selectedIndex() const;
    void setSelectedIndex(int index);

Q_SIGNALS:
    void fileOpenedClicked(int id);

private:
    FileNavigationModel *model_{nullptr};
};

