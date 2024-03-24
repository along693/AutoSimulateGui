#ifndef FILECONTROLLER_H
#define FILECONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <filemanager.h>

class FileController : public QObject
{
    Q_OBJECT
public:
    FileController(QQmlApplicationEngine &engine, QObject *parent = nullptr);

public slots:
    void setFilePath(const QString &filePath);

private slots:
    void onFileNameChanged(const QString &fileName);
    void onFileContentChanged(const QStringList &fileContent);

private:
    QQmlApplicationEngine &m_engine;
    FileManager m_fileManager;
};

#endif // FILECONTROLLER_H
