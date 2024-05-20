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
    Connections {
        target: clipboard
        function onSendFilePath(path) {
            parameter1.text = path
        }
        function onSendMouseCoord(Coord) {
            var result = Coord.split(" ");
            parameter1.text = result[0];
            parameter2.text = result[1];
        }
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
                text: filename + (fileNeedsSaving ? "*" : "")
                ButtonGroup.group: openedFileButtonGroup
                onClicked: mainController.fileNavigationController.fileOpenedClicked(fileId)
                background: Rectangle {
                    color: (FluTheme.darkMode === FluThemeType.Light) ? button.checked? LightTheme.color4 : "transparent" : button.checked? "#262c36" : "#1a1b1e"
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
        color: (FluTheme.darkMode === FluThemeType.Light) ? "#FFFFFF" : "#1a1b1e"
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

    TextArea {
        id: hiddenText
        visible: false

        Component.onCompleted: {
            editorModel.document = hiddenText.textDocument
        }
        onTextChanged: {
            // 将隐藏文本区域的文本按行分割成数组
            var text = hiddenText.text.split("\n");
            var result = [];
            // 遍历隐藏文本的每一行
            for (var i = 0; i < text.length; i++) {
                if (text[i].trim() !== "") {
                    // 创建一个新的数据对象，包含标题和键
                    var newData = {
                        title: text[i].trim(), // 标题为当前行去除空格后的文本
                        key : i
                    };
                    // 将新数据对象添加到结果数组中
                    result.push(newData);
                }
            }
            // 更新树形视图的数据源，以反映最新的数据
            tree_view.updateDataSource(result);
        }

        // onTextChanged: {
            // var text = hiddenText.text.split("\n");
            // var result = [];
            // for (var i = 0; i < text.length; i++) {
                // if (text[i].trim() !== "") {
                    // var newData = {
                        // title: text[i].trim(),
                        // key : i
                    // };
                    // result.push(newData);
                // }
            // }
            // tree_view.updateDataSource(result);
        // }
    }

    function updateHiddenText(text){
        var newText = text.join('\n');
        hiddenText.text = newText + '\n';
    }

    function getAllCommand() {
        var allCommand = tree_view.getAllData();
        var results = []
        for (var i = 0; i < allCommand.length; i ++) {
            results.push(allCommand[i].title);
        }
        return results
    }

    function handleItemClicked(index) {
        var data = tree_view.getAllData();
        var getTitle = data[index].title;
        var command = getTitle.split(" ");
        var keyword = command[0];
        var parameters = command.slice(1);
        keywordComboBox.currentIndex = parseCommandIndex(keyword);
        if (parameters[0] !== undefined) {
            parameter1.text = parameters[0];
        }
        if (parameters[1] !== undefined) {
            parameter2.text = parameters[1];
        }
        if (parameters[2] !== undefined) {
            parameter3.text = parameters[2];
        }
        if (parameters[3] !== undefined) {
            parameter4.text = parameters[3];
        }
    }

    function parseCommandIndex(command) {
        switch (command) {
            case "find":
                return 0;
            case "locate":
                return 1;
            case "click":
                return 2;
            case "scroll":
                return 3;
            case "drag":
                return 4;
            case "capture":
                return 5;
            case "delay":
                return 6;
            case "write":
                return 7;
            case "loop":
                return 8;
            case "endloop":
                return 9;
        }
    }

    function clearInput() {
        parameter1.clear();
        parameter2.clear();
        parameter3.clear();
        parameter4.clear();
    }
    function countEmptyInput() {
        var count = 0;
        if (parameter1.text === '') {
            count += 1;
        }
        if (parameter2.text === '') {
            count += 1;
        }
        if (parameter3.text === '') {
            count += 1;
        }
        if (parameter4.text === '') {
            count += 1;
        }
        print(count)
        return count
    }
    FluTreeView{
        id: tree_view
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: filenamePanel.right
        }
        width: parent.width * 0.71
        cellHeight: 30
        draggable: true
        showLine: true
        checkable:false
        depthPadding: 30
        Component.onCompleted: {
            tree_view.itemClicked.connect(handleItemClicked);
        }
        function appendRow(title) {
            var newData = { title: title, key: title };
            var currentData = tree_view.dataSource;
            currentData.push(newData);
            tree_view.dataSource = currentData;
        }
        function updateDataSource(newDataSource) {
            tree_view.dataSource = newDataSource;
        }

        function getAllTitle() {
            var allData = tree_view.getAllData();
            for (var i = 0; i < allData.length; i ++) {
                print(allData[i].title);
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
            left: tree_view.right
            top: parent.top
            bottom: parent.bottom
        }
        width: parent.width - tree_view.width
        height: parent.height
        color: (FluTheme.darkMode === FluThemeType.Light) ? "#ffffff" : "#1c1c10"

        Column {
            width: rightPanel.width
            height: rightPanel.height

            Rectangle {
                id: actionPanel
                width: rightPanel.width
                height: rightPanel.height / 5 * 2
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
                            onClicked:  mainController.menuController.executeClicked(editorModel.text);
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
                    QtObject {
                        id: viewModel
                        property string text1
                        property string text2
                        property string text3
                        property string text4
                    }
                    FluTextBox {
                        id: parameter1
                        width: rightPanel.width
                        placeholderText: "Parameter 1"
                        visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 0
                        text: viewModel.text1
                        onTextChanged: {
                            viewModel.text1 = text
                        }
                    }
                    FluTextBox {
                        id: parameter2
                        width: rightPanel.width
                        placeholderText: "Parameter 2"
                        visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 1
                        text: viewModel.text2
                        onTextChanged: {
                            viewModel.text2 = text
                        }
                    }
                    FluTextBox {
                        id: parameter3
                        width: rightPanel.width
                        placeholderText: "Parameter 3"
                        visible: keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount > 2
                        text: viewModel.text3
                        onTextChanged: {
                            viewModel.text3 = text
                        }
                    }
                    FluTextBox {
                        id: parameter4
                        width: rightPanel.width
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
                            width: 60
                            onClicked: {
                                if (keywordComboBox.currentIndex === -1) {
                                    showWarning("Please select a keyword.")
                                    return
                                }
                                if (countEmptyInput() - (4 - keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount) > 0){
                                    showWarning("Miss Parameter.")
                                    return
                                }

                                var keyword = keywordComboBox.model.get(keywordComboBox.currentIndex).text;
                                var parameters = [parameter1.text, parameter2.text, parameter3.text, parameter4.text];
                                var parameterString = parameters.join(" ");
                                var command =  keyword + " " + parameterString ;
                                updateHiddenText(getAllCommand());
                                hiddenText.text += command + '\n';
                                clearInput();
                                tree_view.scrollToLastRow();
                            }
                        }
                        FluFilledButton {
                            text: qsTr("Modify")
                            width: 60
                            onClicked: {
                                var currentIndex = tree_view.getCurrentClickedItemIndex();
                                if (currentIndex === -1) {
                                    showWarning("Do not select a command");
                                    return;
                                }
                                if (countEmptyInput() - (4 - keywordComboBox.model.get(keywordComboBox.currentIndex).parameterCount) > 0){
                                    showWarning("Miss Parameter.")
                                    return
                                }
                                updateHiddenText(getAllCommand())
                                var keyword = keywordComboBox.model.get(keywordComboBox.currentIndex).text;
                                var parameters = [parameter1.text, parameter2.text, parameter3.text, parameter4.text];
                                var parameterString = parameters.join(" ");
                                var command =  keyword + " " + parameterString ;
                                var allCommand = hiddenText.text.split('\n');
                                allCommand[currentIndex] = command;
                                updateHiddenText(allCommand);
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
                        FluIconButton {
                            iconSource: FluentIcons.Add
                            iconSize: 15
                            normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                            hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                            visible: keywordComboBox.model.get(keywordComboBox.currentIndex).text === "locate"
                            onClicked: {
                                mainController.windowController.hideApplication()
                                FluRouter.navigate("/screenshot")
                            }
                        }
                        FluIconButton{
                            iconSource: FluentIcons.Click
                            iconSize: 15
                            normalColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color4 : DarkTheme.color4
                            hoverColor: FluTheme.darkMode === FluThemeType.Light ? LightTheme.color1 : DarkTheme.color1
                            visible: keywordComboBox.model.get(keywordComboBox.currentIndex).text === "click"
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
