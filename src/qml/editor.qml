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

                       return FluColors.Green
                   }
                   border.width: 0
                   radius: 0
                }
                contentItem: Text {
                    text: button.text
                    verticalAlignment: Text.AlignVCenter
                    color: Style.fileNavigationTextColor
                }
            }
        }
    }

    Rectangle {
        implicitHeight: parent.height
        implicitWidth: 120
        id: filenamePanel
        color: "#b6ccd8"
        ListView{
            id: fileNames
            anchors.fill: parent
            model: documentsModel
            delegate: openedFilesDelegate
            focus: true
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
    Connections {
        target: fileManager
        function onTextLoaded(text) {
            textArea.text = text
        }
        function onfileNameChanged(filename){
            fileNames.delegate.text = modelData
        }
    }


    FileDialog {
        id: fileDialog
        title: "Select a file"
        nameFilters: ["Text files (*.txt)", "All files (*)"]
        fileMode: FileDialog.OpenFile
        folder: StandardPaths.writableLocation(StandardPaths.HomeLocation)
        onAccepted: {
            var filePath = fileDialog.file.toString();
            fileManager.loadTextFromFile(filePath);
        }
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
                    Row{
                        FluIconButton{
                            iconSource: FluentIcons.GlobalNavButton
                            iconSize: 25
                            normalColor: "#71c4ef"
                            hoverColor: "#d4eaf7"
                            onClicked: {
                                fileDialog.open();
                            }
                        }
                        FluIconButton{
                            iconSource: FluentIcons.GlobalNavButton
                            iconSize: 25
                            normalColor: "#71c4ef"
                        }
                        FluIconButton{
                            iconSource: FluentIcons.GlobalNavButton
                            iconSize: 25
                            normalColor: "#71c4ef"
                        }
                        FluIconButton{
                            iconSource: FluentIcons.GlobalNavButton
                            iconSize: 25
                            normalColor: "#71c4ef"
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
                }
            }
        }
    }
}
