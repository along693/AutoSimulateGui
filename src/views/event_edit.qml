import QtQuick 2.15
import FluentUI
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts
import Qt.labs.platform
import Editor 1.0
import "../styles"

Item{
    property var qmlWindow: null
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
            focus: true
            highlightFollowsCurrentItem: true
            currentIndex: fileNavigationModel.selectedIndex
        }
    }
    TextArea{
        id: hiddenText
        visible: false

        Component.onCompleted: {
            editorModel.document = hiddenText.textDocument
        }
        onTextChanged: {
            var text = hiddenText.text.split("\n");
            var result = [];
            for(var i = 0; i < text.length; i ++) {
                if(text[i].trim() !== "") {
                    result.push(text[i].trim());
                }
            }
            print(result)
            list_model.clear();
            for (i = 0; i < result.length; i ++ ) {
                var word = result[i].split(" ");
                var keyword = word[0];
                var parameters = word.slice(1);
                list_model.append({lable: keyword, text: parameters.join(" ")});
            }
        }
    }
    function clearInput(){
        parameter1.clear();
        parameter2.clear();
        parameter3.clear();
        parameter4.clear();
    }


    FluScrollablePage{
        anchors{
            top: parent.top
            bottom: parent.bottom
            left: filenamePanel.right
        }
        width: parent.width*0.7
        id: event_timeline
        ListModel{
            id:list_model
        }
        FluTimeline{
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            width: parent.width
            model: list_model
            mode: FluTimelineType.Left
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

    Rectangle {
        id: rightPanel
        anchors{
            left: event_timeline.right
            top: parent.top
            bottom: parent.bottom
        }
        width: parent.width - event_timeline.width
        height: parent.height

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
                    onClicked: saveDialog.open()
                }
                FluIconButton{
                    iconSource: FluentIcons.Play
                    iconSize: 20
                    normalColor: LightTheme.color4
                    hoverColor: LightTheme.color1
                    onClicked: Executor.execute(Parser.parse(editorModel.text))
                }
            }
            ListModel{
                id: parameterInput
            }
            FluComboBox {
                id: keywordComboBox
                textRole: "text"
                model: ListModel {
                    ListElement { text: "locate"; parameterCount: 1 }
                    ListElement { text: "click"; parameterCount: 3 }
                    ListElement { text: "scroll"; parameterCount: 2 }
                    ListElement { text: "drag"; parameterCount: 4 }
                    ListElement { text: "capture"; parameterCount: 0 }
                    ListElement { text: "delay"; parameterCount: 1 }
                    ListElement { text: "write"; parameterCount: 1 }
                    ListElement { text: "loop"; parameterCount: 1 }
                    ListElement { text: "endloop"; parameterCount: 0 }
                }
                onCurrentIndexChanged: {
                    clearInput()
                }
            }
            FluViewModel {
                id: viewModel
                property string text1
                property string text2
                property string text3
                property string text4
            }

            FluTextBox {
                id: parameter1
                placeholderText: "Parameter 1"
                visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 0 // 根据当前选定项的 parameterCount 动态设置可见性
                text: viewModel.text1
                onTextChanged: {
                viewModel.text1 = text
                }
            }

            FluTextBox {
                id: parameter2
                placeholderText: "Parameter 2"
                visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 1 // 根据当前选定项的 parameterCount 动态设置可见性
                text: viewModel.text2
                onTextChanged: {
                viewModel.text2 = text
                }
            }

            FluTextBox {
                id: parameter3
                placeholderText: "Parameter 3"
                visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 2 // 根据当前选定项的 parameterCount 动态设置可见性
                text: viewModel.text3
                onTextChanged: {
                viewModel.text3 = text
                }
            }

            FluTextBox {
                id: parameter4
                placeholderText: "Parameter 4"
                visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 3 // 根据当前选定项的 parameterCount 动态设置可见性
                text: viewModel.text4
                onTextChanged: {
                viewModel.text4 = text
                }
            }

            FluFilledButton{
                text: qsTr("Append")
                onClicked: {
                    if (keywordComboBox.currentIndex === -1) {
                        console.log("Please select a keyword.")
                        return
                    }
                    var keyword = keywordComboBox.model.get(keywordComboBox.currentIndex).text;
                    var parameters = [parameter1.text, parameter2.text, parameter3.text, parameter4.text];
                    var parameterString = parameters.join(" ");
                    // list_model.append({lable: keywordComboBox.model.get(keywordComboBox.currentIndex).text, text:parameterString});
                    console.log("keyword:", keywordComboBox.model.get(keywordComboBox.currentIndex).text);
                    console.log("Parameters:", parameterString);
                    hiddenText.text += keyword + " " + parameterString + '\n';
                    clearInput();
                }
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
