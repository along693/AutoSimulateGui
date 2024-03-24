#include "filemanager.h"
#include <QFile>
#include <QTextStream>
#include <QFileInfo>


FileManager::FileManager(QObject *parent) : QObject(parent),
    m_fileNamesModel(new QStringListModel(this))
{
    // Set initial model data
    m_fileNamesModel->setStringList(m_fileNames);
}

QString FileManager::fileName() const
{
    return m_fileName;
}

QStringList FileManager::fileContent() const
{
    return m_fileContent;
}

void FileManager::updateFileInfo(const QString &filePath)
{
    QFile file(filePath);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        // Update file name
        m_fileName = QFileInfo(filePath).fileName();
        emit fileNameChanged(m_fileName);

        // Read file content and calculate line numbers
        m_fileContent.clear();
        QTextStream in(&file);
        int lineNumber = 1;
        while (!in.atEnd())
        {
            QString line = in.readLine();
            m_fileContent.append(QString::number(lineNumber++) + ": " + line);
        }
        file.close();
        emit fileContentChanged(m_fileContent);
    }
}

QString FileManager::removePrefix(const QString &filePath){
    QString tmpUrl = filePath;
    return tmpUrl.replace("file:///","");
}

void FileManager::getNamefromPath(QString Path){
    if (Path.isEmpty()) {
        m_fileName = "untitled";
    } else {
        QStringList parts = Path.split('/');
        if (!parts.isEmpty()) {
            m_fileName = parts.back();
        } else {
            m_fileName = "untitled";
        }
    }
}

void FileManager::loadTextFromFile(const QString &filePath)
{
    QString realPath = removePrefix(filePath);
    QFile file(realPath);
    getNamefromPath(realPath);
    addFileName(m_fileName);

    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QTextStream in(&file);
        QString text = in.readAll();
        file.close();
        emit textLoaded(text);
    }
    else
    {
        qDebug() << "Failed to open file:" << filePath;
    }
}

void FileManager::addFileName(const QString& fileName) {
    if (!m_fileNames.contains(fileName)) {
        m_fileNames.append(fileName);
        m_fileNamesModel->setStringList(m_fileNames);
        emit fileNameChanged(fileName);
    }
}

QStringListModel* FileManager::fileNamesModel() const{
    qDebug() << m_fileNamesModel->stringList();
    return m_fileNamesModel;
}
