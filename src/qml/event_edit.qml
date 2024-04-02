import QtQuick 2.15
import FluentUI
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item{
    property var qmlWindow: null
    FluScrollablePage{
        width: parent.width*0.7
        height: parent.height
        id: event_timeline
        ListModel{
            id:list_model
        }
        FluTimeline{
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.bottomMargin: 20
            width: parent.width
            height: parent.height
            model: list_model
            mode: FluTimelineType.Left
        }
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
                    ListElement { text: "loop"; parameterCount: 0 }
                    ListElement { text: "endloop"; parameterCount: 0 }
                }
                onCurrentIndexChanged: {
                    parameter1.clear();
                    parameter2.clear();
                    parameter3.clear();
                    parameter4.clear();
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
                    var parameters = [parameter1.text, parameter2.text, parameter3.text, parameter4.text]
                    var parameterString = parameters.join(" ");
                    list_model.append({lable: keywordComboBox.model.get(keywordComboBox.currentIndex).text, text:parameterString});
                    console.log("keyword:", keywordComboBox.model.get(keywordComboBox.currentIndex).text)
                    console.log("Parameters:", parameterString)
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
