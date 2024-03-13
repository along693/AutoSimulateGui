import QtQuick 2.15
import QtQuick.Window 2.15
import FluentUI
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform


FluWindow {

    id:window
    visible: true
    width: 960
    height: 600
    minimumWidth: 520
    minimumHeight: 200
    fitsAppBarWindows: true
    FluAcrylic{
        width: window.width
        height: window.height
        anchors.centerIn: parent
    }

    FluObject{
        id: nav_left
        FluPaneItem{
            id: editor
            icon: FluentIcons.Edit
            count: 9
            title:"Edit"
            url: "qrc:/editor.qml"
            onTap:{
                nav_view.push(url)
            }

        }
        FluPaneItem{
            icon: FluentIcons.Event12
            title: "event"
            url: "qrc:/editor.qml"
            onTap:{
                nav_view.push(url)
            }
        }
        FluPaneItemSeparator{
        spacing:5
        size:1
        }
        FluPaneItem{
            icon: FluentIcons.Help
            title:"help"
            url: "qrc:/editor.qml"
            onTap:{
                nav_view.push(url)
            }
        }
    }
    FluNavigationView{
        logo: "qrc:/favicon.ico"
        title:"AutoSimulate"
        id:nav_view
        width: parent.width
        height: parent.height
        displayMode: FluNavigationViewType.Compact
        z:999
        pageMode: FluNavigationViewType.NoStack
        items:nav_left
        Component.onCompleted: {
            nav_view.setCurrentIndex(0)
            nav_view.push("qrc:/editor.qml")
        }
    }
}
