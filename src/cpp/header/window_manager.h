#ifndef WINDOWMANAGER_H
#define WINDOWMANAGER_H

#include <QObject>
#include <QGuiApplication>
#include <QWindow>
#include <QScreen>
#include <QDebug>
#include <QRegularExpression>
#include <windows.h>

class WindowManager : public QObject {
    Q_OBJECT
public:
    static WindowManager& getInstance();
    Q_INVOKABLE QStringList getAllWindowTitles();
    Q_INVOKABLE bool switchToWindow(const QString &targetAppName);
    Q_INVOKABLE void hideApplication();
    Q_INVOKABLE void showApplication();

private:
    explicit WindowManager(QObject *parent = nullptr);

    static WindowManager instance;
};

#endif // WINDOWMANAGER_H

