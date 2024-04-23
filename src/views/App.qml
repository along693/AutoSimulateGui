import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI

FluLauncher {
    id: app
    Component.onCompleted: {
        FluApp.init(app)
        FluTheme.enableAnimation = true
        FluRouter.routes = {
            "/":"qrc:/src/views/main.qml",
            "/add_event":"qrc:/src/views/add_event.qml",
        }
        FluRouter.navigate("/")
    }
}

