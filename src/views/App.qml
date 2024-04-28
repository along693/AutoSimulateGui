import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI

FluLauncher {
    id: app
    Component.onCompleted: {
        FluApp.windowIcon = "qrc:/src/views/favicon.ico"
        FluApp.init(app)
        FluTheme.enableAnimation = true
        FluRouter.routes = {
            "/":"qrc:/src/views/main.qml",
            "/mouse_coord_tracker":"qrc:/src/views/mouse_coord_tracker.qml",
            "/screenshot":"qrc:/src/views/screenshot.qml",
        }
        FluRouter.navigate("/")
    }
}

