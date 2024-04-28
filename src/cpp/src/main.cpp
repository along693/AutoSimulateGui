#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QDebug>
#include <QHotkey>

#include "editor_controller.h"
#include "navigation_controller.h"
#include "main_controller.h"
#include "menu_controller.h"

#include "document_handler.h"
#include "document_model.h"
#include "navigation_model.h"
#include "menu_model.h"
#include "qml_editor_model.h"
#include "window_controller.h"
#include "screenshot.h"
#include "autogui_test.h"
#include "parser.h"
#include "executor.h"
#include "log_controller.h"
#include "clipboard.h"
#include "line_numbers.h"
#include "mouse.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/src/views/favicon.ico"));
    qmlRegisterType<MainController>("Editor", 1, 0, "MainController");
    qmlRegisterType<MenuController>("Editor", 1, 0, "MenuController");
    qmlRegisterType<FileNavigationController>("Editor", 1, 0, "FileNavigationController");
    qmlRegisterType<DocumentHandler>("Editor", 1, 0, "DocumentHandler");
    qmlRegisterType<LineNumbers>("Editor", 1, 0, "LineNumbers");


    MainController main_controller;
    DocumentsModel documents_model;
    main_controller.setDocumentsModel(documents_model);

    QmlEditorModel editor_model;
    main_controller.editorController()->setModel(editor_model);

    MenuModel menu_model;
    main_controller.menuController()->setModel(menu_model);

    FileNavigationModel file_navigation_model;
    main_controller.fileNavigationController()->setModel(file_navigation_model);
    main_controller.menuController()->newFileClicked();

    Screenshot& screenshot = Screenshot::getInstance();
    Clipboard& clipboard = Clipboard::getInstance();
    AutoGuiTester autoGuiTester;


    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("mainController", &main_controller);
    engine.rootContext()->setContextProperty("documentsModel", &documents_model);
    engine.rootContext()->setContextProperty("editorModel", &editor_model);
    engine.rootContext()->setContextProperty("menuModel", &menu_model);
    engine.rootContext()->setContextProperty("fileNavigationModel", &file_navigation_model);
    engine.rootContext()->setContextProperty("screenShot", &screenshot);
    engine.rootContext()->setContextProperty("clipboard", &clipboard);
    engine.rootContext()->setContextProperty("autoGuiTester", &autoGuiTester);

    const QUrl url(QStringLiteral("qrc:/src/views/App.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
