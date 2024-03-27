#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>

#include "editor_controller.h"
#include "navigation_controller.h"
#include "main_controller.h"
#include "menu_controller.h"

#include "document_handler.h"
#include "document_model.h"
#include "navigation_model.h"
#include "menu_model.h"
#include "qml_editor_model.h"
#include "window_manager.h"
#include "screenshot.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    qmlRegisterType<MainController>("Editor", 1, 0, "MainController");
    qmlRegisterType<MenuController>("Editor", 1, 0, "MenuController");
    qmlRegisterType<FileNavigationController>("Editor", 1, 0, "FileNavigationController");
    qmlRegisterType<DocumentHandler>("Editor", 1, 0, "DocumentHandler");


    MainController main_controller;
    DocumentsModel documents_model;
    main_controller.setDocumentsModel(documents_model);

    QmlEditorModel editor_model;
    main_controller.editorController()->setModel(editor_model);

    MenuModel menu_model;
    main_controller.menuController()->setModel(menu_model);

    FileNavigationModel file_navigation_model;
    main_controller.fileNavigationController()->setModel(file_navigation_model);

    main_controller.menuController()->newFileClicked(); //Create a new file to start with!

    WindowManager windowManager;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("mainController", &main_controller);
    engine.rootContext()->setContextProperty("documentsModel", &documents_model);
    engine.rootContext()->setContextProperty("editorModel", &editor_model);
    engine.rootContext()->setContextProperty("menuModel", &menu_model);
    engine.rootContext()->setContextProperty("fileNavigationModel", &file_navigation_model);
    engine.rootContext()->setContextProperty("WindowManager", &windowManager);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
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

    Screenshot screenshot;

    // 指定要截取的区域
    QRect captureRect(100, 100, 300, 200); // 从 (100, 100) 开始截取宽度为 300，高度为 200 的区域

    // 截取指定区域并保存到指定文件
    QString savePath = "D:/captured_area.png"; // 保存路径
    QPixmap capturedImage = screenshot.captureArea(captureRect);
    capturedImage.save(savePath);
    qDebug() << "Captured area saved to" << savePath;

    return app.exec();
}
