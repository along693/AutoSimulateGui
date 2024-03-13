import QtQuick 2.15
import FluentUI
import QtQuick.Controls 2.15

Item {
    id: root
    property alias text: textArea.text
    width: 800
    Rectangle {
        implicitHeight: parent.height
        implicitWidth: 120
        id: filenamePanel
        color: "#b6ccd8"
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
            implicitWidth: 600
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
