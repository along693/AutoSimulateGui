// FileManager.h
#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include <QFile>
#include <QDebug>

class FileManager : public QObject
{
    Q_OBJECT
public:
    explicit FileManager(QObject *parent = nullptr);

    Q_INVOKABLE bool createFile(const QString &fileName);
    Q_INVOKABLE bool createDirectory(const QString &dirName);

private:
    bool setPermissions(const QString &path, QFile::Permissions permissions);
};

#endif // FILEMANAGER_H
