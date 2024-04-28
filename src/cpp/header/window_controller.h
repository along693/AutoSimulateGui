#pragma once

#include <QObject>
#include <QGuiApplication>
#include <QWindow>
#include <QScreen>
#include <QDebug>
#include <QRegularExpression>
#include <windows.h>

class WindowController : public QObject {
    Q_OBJECT

public:
    static WindowController& getInstance();
    Q_INVOKABLE QStringList getAllWindowTitles();
    Q_INVOKABLE bool switchToWindow(const QString &targetAppName);
    Q_INVOKABLE void hideApplication();
    Q_INVOKABLE void showApplication();

private:
    explicit WindowController(QObject *parent = nullptr);
    static WindowController instance;
};
