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
    height: 640
    minimumWidth: 520
    minimumHeight: 200
    fitsAppBarWindows: true


    // FluAcrylic{
        // target: nav_view
        // width: nav_view.width - 100
        // height: nav_view.height -100
        // anchors.centerIn: nav_view
        // tintOpacity: 1
        // blurRadius: 1
    // }

    FluObject{
        id: nav_left
        FluPaneItem{
            id: editor
            icon: FluentIcons.Edit
            count: 9
            title:"Edit"
            url: "qrc:/src/views/editor.qml"
            onTap:{

                nav_view.push(url)
            }

        }
        FluPaneItem{
            icon: FluentIcons.Event12

            title: "event"
            url: "qrc:/src/views/event_edit.qml"
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
            url: "qrc:/src/views/add_event.qml"
            onTap:{
                nav_view.push(url)
            }
        }
    }

    FluObject{
        id: nav_footer
        FluPaneItem{
            id: theme
            icon: FluentIcons.Brightness
            title: "theme"
            onTap:{
                if(FluTheme.dark){
                    FluTheme.darkMode = FluThemeType.Light
                    theme.icon = FluentIcons.Brightness
                }else{
                    FluTheme.darkMode = FluThemeType.Dark
                    theme.icon = FluentIcons.QuietHours
                }

            }

        }

    }

    FluNavigationView{
        title:"AutoSimulate"
        id:nav_view
        width: parent.width
        height: parent.height
        displayMode: FluNavigationViewType.Compact
        z:999
        pageMode: FluNavigationViewType.NoStack
        items:nav_left
        footerItems:nav_footer
        Component.onCompleted: {
            nav_view.setCurrentIndex(0)
            nav_view.push("qrc:/src/views/editor.qml")
        }
    }
}
