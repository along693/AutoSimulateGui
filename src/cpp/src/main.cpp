#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "ImageProcessor.h"
#include "FileManager.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    ImageProcessor imageProcessor;
    QQmlApplicationEngine engine;
    qmlRegisterType<ImageProcessor>("ImageProcessor", 1, 0, "ImageProcessor");

    // Test create folder
    // FileManager fileManager;
    // QString folderName = "screenshot";
    // fileManager.createDirectory(folderName);


    engine.rootContext()->setContextProperty("imageProcessor", &imageProcessor);
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

    return app.exec();
}