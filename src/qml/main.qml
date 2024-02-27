import QtQuick 2.15
import QtQuick.Window 2.15
import FluentUI
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform
import ImageProcessor 1.0

FluWindow {

    id:window
    title: "AutoSimulateGui"
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
        id: item_test
        FluPaneItem{
            id: editor
            icon: FluentIcons.Edit
            count: 9
            title:"Edit"
            url: "qrc:/test.qml"
            onTap:{
                nav_view.push(url)
            }

        }
        FluPaneItem{
            icon: FluentIcons.Event12
            title: "event"
            url: "qrc:/test.qml"
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
            url: "qrc:/test.qml"
            onTap:{
                nav_view.push(url)
            }
        }
    }

    FluNavigationView{
        id:nav_view
        width: parent.width
        height: parent.height
        displayMode: FluNavigationViewType.Compact
        z:999
        pageMode: FluNavigationViewType.NoStack
        items:item_test
        Component.onCompleted: {
            nav_view.setCurrentIndex(0)
            nav_view.push("qrc:/test.qml")
        }
    }
    FluMenuBar{
        id: menu
        visible: true
    }

}
