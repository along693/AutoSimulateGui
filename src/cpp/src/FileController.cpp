#include "filecontroller.h"
#include <QQmlContext>


FileController::FileController(QQmlApplicationEngine &engine, QObject *parent)
    : QObject(parent), m_engine(engine)
{
    // Expose FileManager instance to QML
    m_engine.rootContext()->setContextProperty("fileManager", &m_fileManager);

    // Connect signals and slots
    connect(&m_fileManager, &FileManager::fileNameChanged, this, &FileController::onFileNameChanged);
    connect(&m_fileManager, &FileManager::fileContentChanged, this, &FileController::onFileContentChanged);
}

void FileController::setFilePath(const QString &filePath)
{
    m_fileManager.updateFileInfo(filePath);
}

void FileController::onFileNameChanged(const QString &fileName)
{
    // Update QML UI with new file name
    m_engine.rootObjects().first()->setProperty("fileName", fileName);
}

void FileController::onFileContentChanged(const QStringList &fileContent)
{
    // Update QML UI with new file content
    QVariantList contentList;
    for (const QString &line : fileContent)
    {
        contentList.append(line);
    }
    m_engine.rootObjects().first()->setProperty("fileContent", QVariant::fromValue(contentList));
}
