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
            FluButton {
                id: button
                checked: index === listView.currentIndex
                checkable: true
                anchors.fill: parent
                text: filename + (fileNeedsSaving ? "*" : "")
                ButtonGroup.group: openedFileButtonGroup
                onClicked: mainController.fileNavigationController.fileOpenedClicked(fileId)
                background: Rectangle {
                    color: button.checked ? "lightblue" : "transparent"
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
        }
        width: 120
        height: parent.height
        color: "#71c4ef"
        clip: true
        ListView{
            id: listView
            anchors.fill: parent
            model: documentsModel
            delegate: openedFilesDelegate
        }
    }
    FluRectangle {
        id: lineNumberPanel
        width: 35
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: filenamePanel.right
        }
        color: LightTheme.lineNumberBackground

        LineNumbers {
            id: lineNumbersItem
            anchors.fill: parent

            selectedBackgroundColor: LightTheme.lineNumberSelectedBackgroundColor
            currentBackgroundColor: LightTheme.lineNumberCurrentBackgroundColor
            selectedTextColor: LightTheme.lineNumberSelectedTextColor
            currentTextColor: LightTheme.lineNumberCurrentTextColor
            textColor: LightTheme.lineNumberTextColor
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
        sequence: StandardKey.Save
        onActivated: menuModel.isNewFile ? saveDialog.open() : mainController.menuController.saveFileClicked();
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
                textFormat: Qt.PlainText
                background: null
                font: LightTheme.editorFont
                // font: LightTheme.editorFont
                selectByMouse: true
                selectionColor: LightTheme.lineNumberSelectedTextColor

                Component.onCompleted: {
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

            width: (parent.width - lineNumberPanel.width - filenamePanel.width) / 5
            height: parent.height

            Column {
                width: rightPanel.width
                height: rightPanel.height

                Rectangle {
                    id: actionPanel
                    width: rightPanel.width
                    height: rightPanel.height / 5 * 2
                    color:"#f5f4f1"
                    radius: 30
                    Column{
                        Row{
                            FluIconButton{
                                iconSource: FluentIcons.Page
                                iconSize: 20
                                normalColor: LightTheme.color4
                                hoverColor: LightTheme.color1
                                onClicked: mainController.menuController.newFileClicked();
                            }
                            FluIconButton{
                                iconSource: FluentIcons.FolderOpen
                                iconSize: 20
                                normalColor: LightTheme.color4
                                hoverColor: LightTheme.color1
                                onClicked: openDialog.open()
                            }
                            FluIconButton{
                                iconSource: FluentIcons.SaveAs
                                iconSize: 20
                                normalColor: LightTheme.color4
                                hoverColor: LightTheme.color1
                                // onClicked: saveDialog.open()
                                onClicked: FindApplication.switchToWindow("python");
                            }
                            FluIconButton{
                                iconSource: FluentIcons.Click
                                iconSize: 20
                                normalColor: LightTheme.color4
                                hoverColor: LightTheme.color1
                                onClicked:{
                                    WindowManager.hideApplication()
                                    getCusCom.source = "getCus.qml";
                                }
                            }
                        }
                        Row{
                            FluIconButton{
                                iconSource: FluentIcons.Add
                                iconSize: 20
                                normalColor: LightTheme.color4
                                hoverColor: LightTheme.color1
                                onClicked: {
                                    WindowManager.hideApplication();
                                    screenShotCom.source = "screenshot.qml";
                                }
                            }
                            FluIconButton{
                                iconSource: FluentIcons.Play
                                iconSize: 20
                                normalColor: LightTheme.color4
                                hoverColor: LightTheme.color1
                                onClicked: Executor.execute(Parser.parse(editorModel.text))
                            }
                        }
                    }
                    Loader{
                        id: screenShotCom
                        onLoaded: {
                            item.closing.connect(function (){
                                screenShotCom.source = "";
                            });
                        }
                    }
                    Loader{
                        id: getCusCom
                        onLoaded: {
                            item.closing.connect(function (){
                                getCusCom.source = "";
                            });
                        }
                    }
                }

                Rectangle {
                    id: splitLine
                    width: rightPanel.width
                    height: rightPanel.height / 5
                    color: "#fffefb"
                }

                Rectangle {
                    id: logPanel
                    width: rightPanel.width
                    height: rightPanel.height / 5 * 2
                    color: "#f5f4f1"
                    radius: 30
                    clip: true
                    ListView {
                        id: logView
                        anchors.fill: parent
                        model: LogController.logs

                        delegate: Text {
                            text: modelData
                            width: rightPanel.width
                            wrapMode: Text.WrapAnywhere
                            font: LightTheme.logFont
                        }
                        Component.onCompleted: {
                            LogController.addLog(LogController.Info, "This is an info message.");
                        }
                        onCountChanged: {
                            // 在添加新项目时滚动到最后一行
                            positionViewAtEnd();
                        }
                    }
                }
            }
        }
}
