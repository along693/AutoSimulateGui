import QtQuick 2.15
import QtQuick.Window 2.15
import FluentUI
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform


FluWindow {
    id:window
    visible: true
    width: 1060
    height: 640
    minimumWidth: 520
    minimumHeight: 200
    fitsAppBarWindows: true
    FluContentDialog{
        id: dialog_close
        title: qsTr("Quit")
        message: qsTr("Are you sure you want to exit?")
        negativeText: qsTr("Minimize")
        buttonFlags: FluContentDialogType.NegativeButton | FluContentDialogType.NeutralButton | FluContentDialogType.PositiveButton
        positiveText: qsTr("Quit")
        neutralText: qsTr("Cancel")
        onNegativeClicked: {
            mainController.windowController.hideApplication();
        }
        onPositiveClicked:{
            FluRouter.exit(0)
        }
    }
    appBar: FluAppBar {
        width: window.width
        height: 30
        showDark: true
        darkClickListener:(button)=>handleDarkChanged(button)
        closeClickListener: ()=>{dialog_close.open()}
        z:7
    }

    function handleDarkChanged() {
        /* 当前是黑夜模式的话就换到白天模式，否则切换到黑夜模式*/
        FluTheme.darkMode = FluTheme.dark ?
        FluThemeType.Light : FluThemeType.Dark;
    }

    FluObject{
        id: nav_left
        FluPaneItem{
            id: editor
            icon: FluentIcons.Edit
            count: 9
            title:"Edit"
            url: "qrc:/src/views/code_editor.qml"
            onTap:{

                nav_view.push(url)
            }

        }
        FluPaneItem{
            icon: FluentIcons.Event12
            title: "event"
            url: "qrc:/src/views/event_editor.qml"
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
            url: "qrc:/src/views/help.qml"
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
        logo: "qrc:/src/views/favicon.ico"
        displayMode: FluNavigationViewType.Compact
        z:999
        pageMode: FluNavigationViewType.NoStack
        items:nav_left
        // footerItems:nav_footer
        Component.onCompleted: {
            nav_view.setCurrentIndex(0)
            nav_view.push("qrc:/src/views/code_editor.qml")
        }
    }
}
