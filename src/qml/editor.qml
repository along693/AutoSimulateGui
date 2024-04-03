import QtQuick 2.15
import FluentUI
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import Qt.labs.platform
import Editor 1.0

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
            Button {
                id: button
                checked: index === listView.currentIndex
                checkable: true
                anchors.fill: parent
                text: filename + (fileNeedsSaving ? "*" : "")
                ButtonGroup.group: openedFileButtonGroup
                onClicked: mainController.fileNavigationController.fileOpenedClicked(fileId)
                background: Rectangle {
                   color: {
                       if (button.checked) {
                           return FluColors.White
                       }
                       if (button.hovered) {
                           return FluColors.Blue
                       }
                       return FluColors.Grey110
                   }
                   border.width: 0
                   radius: 0
                }
                contentItem: Text {
                    text: button.text
                    verticalAlignment: Text.AlignVCenter
                    color: "#1d195e"
                }
            }
        }
    }

    Rectangle {
        implicitHeight: parent.height
        implicitWidth: 120
        id: filenamePanel
        color: "#b6ccd8"
        clip: true
        ListView{
            id: listView
            anchors.fill: parent
            model: documentsModel
            delegate: openedFilesDelegate
        }
    }

    Rectangle {
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: filenamePanel.right
        }
        width: 30
        height: root.height
        id: lineNumberPanel
        color: "#cccbc8"
        ListView {
            anchors.fill: parent
            model: fileLineContent
            delegate: Text {
                text: modelData
            }
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

    FluSplitLayout {
        id: splitView
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            left: lineNumberPanel.right
        }
        Flickable {
            id: textEditor
            width: parent.width - lineNumberPanel.width - filenamePanel.width
            height: parent.height
            implicitWidth: 580
            implicitHeight: parent.height
            contentWidth: textEditor.width
            contentHeight: textEditor.height
            boundsBehavior: Flickable.StopAtBounds
            TextArea.flickable: TextArea {
                id: textArea
                textFormat: Qt.PlainText
                font: FluTextStyle.Subtitle
                background: null
                selectByMouse: true
                wrapMode: TextEdit.WordWrap
                Component.onCompleted: {
                    editorModel.document = textArea.textDocument
                }
            }
            ScrollBar.vertical: FluScrollBar {}
            ScrollBar.horizontal: FluScrollBar {}
        }

        Rectangle {
            id: rightPanel
            width: (root.width - lineNumberPanel.width) * 1 / 3
            height: splitView.height

            Column {
                width: rightPanel.width
                height: rightPanel.height

                Rectangle {
                    id: actionPanel
                    width: rightPanel.width
                    height: rightPanel.height / 2
                    color:"#f5f4f1"
                    radius: 30
                    Column{
                        Row{
                            FluIconButton{
                                iconSource: FluentIcons.GlobalNavButton
                                iconSize: 25
                                normalColor: "#71c4ef"
                                hoverColor: "#d4eaf7"
                                onClicked: mainController.menuController.newFileClicked();
                            }
                            FluIconButton{
                                iconSource: FluentIcons.GlobalNavButton
                                iconSize: 25
                                normalColor: "#71c4ef"
                                onClicked: openDialog.open()
                            }
                            FluIconButton{
                                iconSource: FluentIcons.GlobalNavButton
                                iconSize: 25
                                normalColor: "#71c4ef"
                                onClicked: saveDialog.open()
                            }
                            FluIconButton{
                                iconSource: FluentIcons.GlobalNavButton
                                iconSize: 25
                                normalColor: "#71c4ef"
                                 onClicked: WindowManager.hideApplication()
                            }
                        }
                        Row{
                            FluIconButton{
                                iconSource: FluentIcons.GlobalNavButton
                                iconSize: 25
                                normalColor: "#71c4ef"
                                 onClicked: {screenShotCom.source = "screenshot.qml";}
                            }
                            FluIconButton{
                                iconSource: FluentIcons.GlobalNavButton
                                iconSize: 25
                                normalColor: "#71c4ef"
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
                }

                Rectangle {
                    id: splitLine
                    width: rightPanel.width
                    height: 5
                    color: "#fffefb"
                }

                Rectangle {
                    id: logPanel
                    width: rightPanel.width
                    height: rightPanel.height / 2
                    color: "#f5f4f1"
                    radius: 30
                    clip: true
                    ListView {
                        id: logView
                        anchors.fill: parent
                        model: messageModel

                        delegate: Text {
                            text: modelData
                            width: rightPanel.width
                            wrapMode: Text.WrapAnywhere
                        }
                    }

                    ListModel {
                        id: messageModel
                    }

                    Connections {
                        target: logController
                        onMessageReceived: {
                            print(message)
                            if(message.startsWith("qrc:")){
                                console.log(message);
                            } else {
                                console.log(message);
                                messageModel.append({message: message})
                                logView.positionViewAtIndex(logView.count - 1, ListView.End)
                            }
                        }
                    }
                }
            }
        }
    }
}
