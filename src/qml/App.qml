import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI

Item {
    id: app
    Component.onCompleted: {
        FluApp.init(app)
        FluTheme.enableAnimation = true
        FluApp.routes = {
            "/":"qrc:/main.qml",
            "/add_event":"qrc:/add_event.qml",
        }
        FluApp.navigate("/")
    }
}

