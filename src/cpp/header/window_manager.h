// windowmanager.h
#ifndef WINDOWMANAGER_H
#define WINDOWMANAGER_H

#include <QObject>
#include <QGuiApplication>
#include <QWindow>

class WindowManager : public QObject
{
    Q_OBJECT
public:
    explicit WindowManager(QObject *parent = nullptr) : QObject(parent) {
        updateScreenSize();
    }

    int screenWidth() const {
        return m_screenWidth;
    }

    int screenHeight() const {
        return m_screenHeight;
    }

public slots:
    void hideApplication() {
        QList<QWindow *> windows = QGuiApplication::topLevelWindows();
        if (!windows.isEmpty()) {
            windows.first()->setWindowState(Qt::WindowMinimized);
        }
    }

    void showApplication() {
        QList<QWindow *> windows = QGuiApplication::topLevelWindows();
        if (!windows.isEmpty()) {
            windows.first()->show();
            windows.first()->raise();
            windows.first()->requestActivate();
        }
    }

private:
    int m_screenWidth;
    int m_screenHeight;

    void updateScreenSize() {
        QScreen *screen = QGuiApplication::primaryScreen();
        if (screen) {
            m_screenWidth = screen->geometry().width();
            m_screenHeight = screen->geometry().height();
        } else {
            m_screenWidth = 0;
            m_screenHeight = 0;
        }
        qDebug() << m_screenHeight << " " << m_screenWidth;
    }
};

#endif // WINDOWMANAGER_H
