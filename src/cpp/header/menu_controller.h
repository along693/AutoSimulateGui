#pragma once

#include <QObject>

class QUrl;

class MenuModel;
class DocumentHandler;

class MenuController : public QObject
{
Q_OBJECT
    Q_DISABLE_COPY_MOVE(MenuController)

public:
    explicit MenuController(QObject *parent = nullptr);

    void setModel(MenuModel &model);
    void setDocument(DocumentHandler &document_handler);

Q_SIGNALS:
    void newFileClicked();
    void openFileClicked(const QUrl &file_url);
    void saveFileClicked();
    void saveAsFileClicked(const QUrl &file_url);

private:
    MenuModel *model_{nullptr};
};
