#pragma once

#include <QObject>
#include <QString>

#include "editor_controller.h"
#include "navigation_controller.h"
#include "menu_controller.h"
#include "window_controller.h"
#include "log_controller.h"

class DocumentsModel;

class MainController : public QObject
{
Q_OBJECT
    Q_DISABLE_COPY_MOVE(MainController)

    Q_PROPERTY(MenuController *menuController READ menuController CONSTANT)
    Q_PROPERTY(EditorController *editorController READ editorController CONSTANT)
    Q_PROPERTY(FileNavigationController *fileNavigationController READ fileNavigationController CONSTANT)
    Q_PROPERTY(WindowController *windowController READ windowController CONSTANT)
    Q_PROPERTY(LogController *logController READ logController CONSTANT)

public:
    explicit MainController(QObject *parent = nullptr);

    void setDocumentsModel(DocumentsModel &documents_model);

    MenuController *menuController();
    EditorController *editorController();
    FileNavigationController *fileNavigationController();
    WindowController* windowController();
    LogController* logController();

private:
    void storeTextToCurrentFile();

    MenuController menu_controller_;
    EditorController editor_controller_;
    FileNavigationController file_navigation_controller_;
    WindowController& window_controller_ = WindowController::getInstance();
    LogController& log_controller_ = LogController::getInstance();
    DocumentsModel *documents_model_{nullptr};
    QMetaObject::Connection document_created_connection_;

private Q_SLOTS:
    void handleEditorTextChanged();
    void openDocument(int id);
    void handleSaveFileClicked();
    void handleSaveAsFileClicked(const QUrl &url);
    void handleNewFileClicked();
    void handleOpenedFileClicked(int id);
    void handleOpenFileClicked(const QUrl &url);
    void handleExecuteClicked(const QString &text);
};

