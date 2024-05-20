import QtQuick
import FluentUI
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts
import Qt.labs.platform
import Editor 1.0
import "../styles"

Item {
    id: root
    property alias text: textArea.text
    width: 800

    ButtonGroup {
        id: openedFileButtonGroup
    }

    Component {
        id: openedFilesDelegate
        Item {
            width: filenamePanel.width
            height: 25
            FluTextButton {
                id: button
                checked: index === listView.currentIndex
                checkable: true
                anchors.fill: parent
                // 显示的文本内容为文件的名字加上是否需要保存的标识符
                text: filename + (fileNeedsSaving ? "*" : "")
                // 当点击文件名的时候触发fileOpenedClick信号，进而判断是否要改变编辑器的文本内容
                onClicked: mainController.fileNavigationController.fileOpenedClicked(fileId)
                ButtonGroup.group: openedFileButtonGroup
                background: Rectangle {
                    // color: button.checked ? "#FFB9DDFF" : "transparent"
                    color: (FluTheme.darkMode === FluThemeType.Light) ? button.checked? LightTheme.buttonCheckedColor : LightTheme.buttonUnCheckedColor : button.checked? DarkTheme.buttonCheckedColor : DarkTheme.buttonUnCheckedColor
                    radius: 10
                }
            }
        }
    }

    FluRectangle {
        id: filenamePanel
        anchors{
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            topMargin: 4
        }
        width: 120
        height: parent.height
        color: (FluTheme.darkMode === FluThemeType.Light) ? LightTheme.filenamePanelColor : DarkTheme.filenamePanelColor
        clip: true
        ListView{
            id: listView
            anchors.fill: parent
            model: documentsModel
            delegate: openedFilesDelegate
            focus: true
            highlightFollowsCurrentItem: true
            currentIndex: fileNavigationModel.selectedIndex
        }
    }
    FluRectangle {
        id: lineNumberPanel
        width: 35
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: filenamePanel.right
            topMargin: 4

        }
        color: (FluTheme.darkMode === FluThemeType.Light) ? LightTheme.lineNumberPanelColor : DarkTheme.lineNumberPanelColor

        LineNumbers {
            id: lineNumbersItem
            anchors.fill: parent

            selectedBackgroundColor: LightTheme.lineNumberSelectedBackgroundColor
            currentBackgroundColor: LightTheme.lineNumberCurrentBackgroundColor
            selectedTextColor: LightTheme.lineNumberSelectedTextColor
            currentTextColor: LightTheme.lineNumberCurrentTextColor
            textColor: (FluTheme.darkMode === FluThemeType.Light) ? LightTheme.lineNumberTextColor : DarkTheme.lineNumberTextColor
            font: LightTheme.editorFont

            document: textArea.textDocument
            cursorPosition: textArea.cursorPosition
            selectionStart: textArea.selectionStart
            selectionEnd: textArea.selectionEnd
            offsetY: textEditor.contentY
        }
    }

    FileDialog {
        id: openDialog
        fileMode: FileDialog.OpenFile
        selectedNameFilter.index: 1
        nameFilters: ["*"]
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: mainController.menuController.openFileClicked(file)
    }

    FileDialog {
        id: saveDialog
        fileMode: FileDialog.SaveFile
        nameFilters: openDialog.nameFilters
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        onAccepted: mainController.menuController.saveAsFileClicked(file);
    }

    Shortcut {
        id: openShortcut
        sequence: StandardKey.Open
        onActivated: openDialog.open()
    }

    Shortcut {
        id: saveAsShortcut
        sequence: StandardKey.SaveAs
        onActivated: saveDialog.open()
    }

    Shortcut {
        id: saveShortcut
        sequence: StandardKey.Save // 定义快捷键为Ctrl+s
        // 当快捷键被触发时执行的操作
        onActivated: mainController.menuController.saveFileClicked();
    }


    Shortcut {
        id: newShortcut
        sequence: StandardKey.New
        onActivated: mainController.menuController.newFileClicked();
    }

        Flickable {
            id: textEditor
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: lineNumberPanel.right
                leftMargin: 4
            }
            width: (parent.width - lineNumberPanel.width - filenamePanel.width) / 5 * 4
            clip: true
            contentWidth: textArea.width
            contentHeight: textArea.height
            onContentYChanged: lineNumbersItem.update()
            boundsBehavior: Flickable.StopAtBounds

            TextArea.flickable: TextArea {
                id: textArea
                textFormat: TextEdit.RichText
                background: null
                font: LightTheme.editorFont
                selectByMouse: true
                selectionColor: LightTheme.lineNumberSelectedTextColor
                color: FluTheme.darkMode === FluThemeType.Light ? LightTheme.textColor : DarkTheme.textColor
                Component.onCompleted: {
                    //在文本编辑组件初始化的时候，将其和编辑器模型的document变量绑定到一起
                    //实现了文本编辑的同步
                    editorModel.document = textArea.textDocument
                }
            }
            ScrollBar.vertical: FluScrollBar {}
            ScrollBar.horizontal: FluScrollBar {}
        }

        FluRectangle {
            id: rightPanel
            anchors{
                top: parent.top
                bottom: parent.bottom
                left: textEditor.right
            }
            color: (FluTheme.darkMode === FluThemeType.Light) ? LightTheme.rectangleColor : DarkTheme.rectangleColor

            width: (parent.width - lineNumberPanel.width - filenamePanel.width) / 5 + 5
            height: parent.height

            Column {
                width: rightPanel.width
                height: rightPanel.height

                Rectangle {
                    id: actionPanel
                    width: rightPanel.width
                    height: rightPanel.height / 5 * 2
                    color: (FluTheme.darkMode === FluThemeType.Light) ? "#f5f4f1" : "#1c1c10"
                    radius: 30
                    Column{
                        Row{
                            FluIconButton{
                                iconSource: FluentIcons.Page
                                iconSize: 20
                                normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                                hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                                onClicked: mainController.menuController.newFileClicked();
                            }
                            FluIconButton{
                                iconSource: FluentIcons.OpenFolderHorizontal
                                iconSize: 20
                                normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                                hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                                onClicked: openDialog.open()
                            }
                            FluIconButton{
                                iconSource: FluentIcons.SaveAs
                                iconSize: 20
                                normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                                hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                                onClicked: saveDialog.open()
                            }
                            FluIconButton{
                                iconSource: FluentIcons.Play
                                iconSize: 20
                                normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                                hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                                onClicked: {
                                    mainController.menuController.executeClicked(editorModel.text);
                                }
                            }
                        }
                        Row{
                            FluIconButton{
                                iconSource: FluentIcons.Add
                                iconSize: 20
                                normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                                hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                                onClicked: {
                                    mainController.windowController.hideApplication()
                                    // autoGuiTester.runTests();
                                    FluRouter.navigate("/screenshot")
                                }
                            }
                            FluIconButton{
                                iconSource: FluentIcons.Click
                                iconSize: 20
                                normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                                hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                                onClicked:{
                                    mainController.windowController.hideApplication()
                                    FluRouter.navigate("/mouse_coord_tracker")
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    id: splitLine
                    width: rightPanel.width
                    height: rightPanel.height / 5
                    color: (FluTheme.darkMode === FluThemeType.Light) ? "#FFFFFF" : "#1a1a1a"
                }

                Rectangle {
                    id: logPanel
                    width: rightPanel.width
                    height: rightPanel.height / 5 * 2
                    color: (FluTheme.darkMode === FluThemeType.Light) ? "#f5f4f1" : "#1c1c10"
                    radius: 30
                    clip: true
                    ListView {
                        id: logView
                        anchors.fill: parent
                        model: logModel
                        clip: true

                        delegate: FluText {
                            text: log
                            width: rightPanel.width
                            wrapMode: Text.WrapAnywhere
                            font: LightTheme.logFont
                            color: (FluTheme.darkMode === FluThemeType.Light) ? "#037cde" : "#428498"
                        }
                        onCountChanged: {
                            positionViewAtEnd();
                        }
                    }
                }
            }
        }
}
