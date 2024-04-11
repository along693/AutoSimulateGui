import QtQuick 2.15
import FluentUI
import QtQuick.Controls 2.15
import QtQuick.Dialogs
import QtQuick.Layouts
import Qt.labs.platform
import Editor 1.0
import "../styles"

Item {
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
                    color: (FluTheme.darkMode === FluThemeType.Light) ?
                        (button.checked ? LightTheme.color4 : "transparent") :
                        (button.checked ? "#262c36" : "#1a1b1e")
                    radius: 10
                }
            }
        }
    }

    FluRectangle {
        id: filenamePanel
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            topMargin: 4
        }
        width: 120
        height: parent.height
        color: (FluTheme.darkMode === FluThemeType.Light) ? "#FFFFFF" : "#1a1b1e"
        clip: true
        ListView {
            id: listView
            anchors.fill: parent
            model: documentsModel
            delegate: openedFilesDelegate
            focus: true
            highlightFollowsCurrentItem: true
            currentIndex: fileNavigationModel.selectedIndex
        }
    }

    TextArea {
        id: hiddenText
        visible: false

        Component.onCompleted: {
            editorModel.document = hiddenText.textDocument
        }
        onTextChanged: {
            var text = hiddenText.text.split("\n");
            var result = [];
            for (var i = 0; i < text.length; i++) {
                if (text[i].trim() !== "") {
                    result.push(text[i].trim());
                }
            }
            list_model.clear();
            for (i = 0; i < result.length; i++) {
                var word = result[i].split(" ");
                var keyword = word[0];
                var parameters = word.slice(1).join(" ");
                list_model.append({lable: keyword, text: parameters});
            }
        }
    }

    function clearInput() {
        parameter1.clear();
        parameter2.clear();
        parameter3.clear();
        parameter4.clear();
    }

    FluScrollablePage {
        id: event_timeline
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: filenamePanel.right
        }
        width: parent.width * 0.7
        ListModel {
            id: list_model
        }
        FluTimeline {
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

    FileDialog {
        id: getFileNameDialog
        title: "GetFileName"
        nameFilters: ["Images (*.png *.jpg)", "All Files (*)"]
        fileMode: FileDialog.OpenFile
        onAccepted: {
            var filePath = getFileNameDialog.currentFile.toString().substring(8)
            parameter1.text = filePath
        }
    }

    Shortcut {
        id: openShortcut
        sequence: StandardKey.Open
        onActivated: openDialog.open()
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
        anchors {
            left: event_timeline.right
            top: parent.top
            bottom: parent.bottom
        }
        width: parent.width - event_timeline.width
        height: parent.height
        color: (FluTheme.darkMode === FluThemeType.Light) ? "#ffffff" : "#1c1c10"

        Column {
            width: rightPanel.width
            height: rightPanel.height

            Rectangle {
                id: actionPanel
                width: rightPanel.width
                height: rightPanel.height / 2
                color: (FluTheme.darkMode === FluThemeType.Light) ? "#f5f4f1" : "#1c1c10"
                radius: 30
                Column {
                    Row {
                        FluIconButton {
                            iconSource: FluentIcons.Page
                            iconSize: 20
                            normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                            hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                            onClicked: mainController.menuController.newFileClicked();
                        }
                        FluIconButton {
                            iconSource: FluentIcons.OpenFolderHorizontal
                            iconSize: 20
                            normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                            hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                            onClicked: openDialog.open()
                        }
                        FluIconButton {
                            iconSource: FluentIcons.SaveAs
                            iconSize: 20
                            normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                            hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                            onClicked: saveDialog.open()
                        }
                        FluIconButton {
                            iconSource: FluentIcons.Play
                            iconSize: 20
                            normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                            hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                            onClicked: Executor.execute(Parser.parse(editorModel.text))
                        }
                    }
                    Rectangle {
                        id: space
                        width: rightPanel.width
                        height: 20
                        color: (FluTheme.darkMode === FluThemeType.Light) ? "#f5f4f1" : "#1c1c10"
                    }
                    ListModel {
                        id: parameterInput
                    }
                    FluComboBox {
                        id: keywordComboBox
                        textRole: "text"
                        model: ListModel {
                            ListElement { text: "find"; parameterCount: 1 }
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
                        visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 0
                        text: viewModel.text1
                        onTextChanged: {
                            viewModel.text1 = text
                        }
                    }
                    FluTextBox {
                        id: parameter2
                        placeholderText: "Parameter 2"
                        visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 1
                        text: viewModel.text2
                        onTextChanged: {
                            viewModel.text2 = text
                        }
                    }
                    FluTextBox {
                        id: parameter3
                        placeholderText: "Parameter 3"
                        visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 2
                        text: viewModel.text3
                        onTextChanged: {
                            viewModel.text3 = text
                        }
                    }
                    FluTextBox {
                        id: parameter4
                        placeholderText: "Parameter 4"
                        visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 3
                        text: viewModel.text4
                        onTextChanged: {
                            viewModel.text4 = text
                        }
                    }
                    Rectangle {
                        id: space2
                        width: rightPanel.width
                        height: 10
                        color: (FluTheme.darkMode === FluThemeType.Light) ? "#f5f4f1" : "#1c1c10"
                    }
                    Row {
                        FluFilledButton {
                            text: qsTr("Append")
                            onClicked: {
                                if (keywordComboBox.currentIndex === -1) {
                                    console.log("Please select a keyword.")
                                    return
                                }
                                var keyword = keywordComboBox.model.get(keywordComboBox.currentIndex).text;
                                var parameters = [parameter1.text, parameter2.text, parameter3.text, parameter4.text];
                                var parameterString = parameters.join(" ");
                                console.log("keyword:", keywordComboBox.model.get(keywordComboBox.currentIndex).text);
                                console.log("Parameters:", parameterString);
                                hiddenText.text += keyword + " " + parameterString + '\n';
                                clearInput();
                            }
                        }
                        FluIconButton {
                            iconSource: FluentIcons.ExploreContent
                            iconSize: 15
                            normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                            hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                            visible: keywordComboBox.model.get(keywordComboBox.currentIndex).text === "locate"
                            onClicked: {
                                getFileNameDialog.open();
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: splitLine
                width: rightPanel.width
                height: 5
                color: (FluTheme.darkMode === FluThemeType.Light) ? "#FFFFFF" : "#1a1a1a"
            }
            Rectangle {
                id: logPanel
                width: rightPanel.width
                height: rightPanel.height / 2
                color: (FluTheme.darkMode === FluThemeType.Light) ? "#f5f4f1" : "#1c1c10"
                radius: 30
            }
        }
    }
}
