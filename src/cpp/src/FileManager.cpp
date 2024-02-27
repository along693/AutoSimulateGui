#include "FileManager.h"
#include <QDir>
#include <QFile>
#include <QStandardPaths>

FileManager::FileManager(QObject *parent) : QObject(parent) {}

bool FileManager::createFile(const QString &fileName)
{
    QString filePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" + fileName;

    QFile file(filePath);
    if (file.exists()) {
        qDebug() << "File already exists:" << filePath;
        return false;
    }

    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "Failed to open file for writing:" << filePath;
        return false;
    }

    file.close();

    // Set file permissions
    if (!file.setPermissions(QFile::ReadOwner | QFile::WriteOwner |
                             QFile::ReadUser | QFile::WriteUser |
                             QFile::ReadGroup | QFile::WriteGroup |
                             QFile::ReadOther | QFile::WriteOther)) {
        qDebug() << "Failed to set file permissions:" << filePath;
        return false;
    }

    // Verify permissions
    QFile::Permissions actualPermissions = file.permissions();
    qDebug() << "Actual permissions for" << filePath << ":" << actualPermissions;

    qDebug() << "File created:" << filePath;
    return true;
}
bool FileManager::createDirectory(const QString &dirName)
{
    QString dirPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/" + dirName;

    QDir dir(dirPath);
    if (dir.exists()) {
        qDebug() << "Directory already exists:" << dirPath;
        return false;
    }

    if (!dir.mkpath(".")) {
        qDebug() << "Failed to create directory:" << dirPath;
        return false;
    }

    // Set directory permissions
    QFile file(dirPath);
    if (!file.setPermissions(QFile::ReadOwner | QFile::WriteOwner |
                             QFile::ReadUser | QFile::WriteUser |
                             QFile::ReadGroup | QFile::WriteGroup |
                             QFile::ReadOther | QFile::WriteOther)) {
        qDebug() << "Failed to set directory permissions:" << dirPath;
        return false;
    }

    // Verify permissions
    QFile::Permissions actualPermissions = file.permissions();
    qDebug() << "Actual permissions for" << dirPath << ":" << actualPermissions;

    qDebug() << "Directory created:" << dirPath;
    return true;
}


bool FileManager::setPermissions(const QString &path, QFile::Permissions permissions)
{
    return QFile::setPermissions(path, permissions);
}
