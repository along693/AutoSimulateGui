#ifndef FILEMANAGER_H
#define FILEMANAGER_H

#include <QObject>
#include <QString>
#include <QList>
#include <QStringListModel>

class FileManager : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QStringListModel* fileNamesModel READ fileNamesModel NOTIFY fileNameChanged)
    explicit FileManager(QObject *parent = nullptr);
    Q_INVOKABLE void loadTextFromFile(const QString &filePath);
    Q_INVOKABLE void addFileName(const QString& fileName);

    QStringListModel* fileNamesModel() const;
    QString removePrefix(const QString &filePath);
    void getNamefromPath(QString Path);

    QString fileName() const;
    QStringList fileContent() const;

signals:
    void fileNameChanged(const QString &fileName);
    void fileContentChanged(const QStringList &fileContent);
    void textLoaded(const QString &text);

public slots:
    void updateFileInfo(const QString &filePath);

private:
    QString m_fileName;
    QStringList m_fileContent;
    QStringList m_fileNames;
    QStringListModel* m_fileNamesModel;
};

#endif // FILEMANAGER_H
