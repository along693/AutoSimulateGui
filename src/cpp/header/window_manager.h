#ifndef WINDOWMANAGER_H
#define WINDOWMANAGER_H

#include <QObject>
#include <QGuiApplication>
#include <QWindow>
#include <QScreen>
#include <QDebug>
#include <QRegularExpression>

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

    HWND getMainWindowHandle() {
        QScreen *primaryScreen = QGuiApplication::primaryScreen();
        if (primaryScreen) {
            QWindowList windows = QGuiApplication::allWindows();
            for (QWindow *window : windows) {
                if (window->screen() == primaryScreen) {
                    qDebug() << window->winId();
                    return reinterpret_cast<HWND>(window->winId());
                }
            }
        }
        return nullptr;
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
    }
};

#endif // WINDOWMANAGER_H
