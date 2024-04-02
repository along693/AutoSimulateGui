import QtQuick 2.15
import QtQuick.Layouts
import FluentUI

FluWindow {
    id: window
    title: qsTr("Add Event")
    width: 500
    height: 600
    fixSize: true
    launchMode: FluWindowType.SingleTask

    ListModel {
        id: parameterInputsModel
    }
    ListModel {
        id: parameterDescriptionsModel
        ListElement { description: "X-coordinate" }
        ListElement { description: "Y-coordinate" }
        ListElement { description: "Type (0 for left-click, 1 for right-click)" }
        ListElement { description: "Value indicating the scroll range" }
        ListElement { description: "Value indicating the direction of scrolling (0 for up, 1 for down)" }
        ListElement { description: "X-coordinate of the left point" }
        ListElement { description: "Y-coordinate of the left point" }
        ListElement { description: "X-coordinate of the right point" }
        ListElement { description: "Y-coordinate of the right point" }
        ListElement { description: "Delay time in seconds" }
        ListElement { description: "String to be written on the screen" }
    }


    ColumnLayout {
        anchors.fill: parent

        FluComboBox {
            id: keywordComboBox
            Layout.alignment: Qt.AlignCenter
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
                if (currentIndex !== -1) {
                    var parameterCount = model.get(currentIndex).parameterCount;
                    createParameterInputs(parameterCount);
                }
            }
        }

        ListView {
            id: parameterInputsList
            width: parent.width
            height: Math.min(parent.height - keywordComboBox.height, 300) // 设置一个固定高度或根据需要调整
            spacing: 10
            model: parameterInputsModel

            delegate: Item {
                width: parent.width
                height: 40 // 设置一个合适的高度
                RowLayout {
                    width: parent.width
                    spacing: 10

                    Repeater {
                        model: parameterDescriptionsModel
                        Text {
                            text: modelData.description !== undefined ? modelData.description : "N/A"
                        }
                    }
                }
            }
        }

    }


    function createParameterInputs(count) {
        parameterInputsModel.clear();
        for (var i = 0; i < count; ++i) {
            parameterInputsModel.append({});
        }
    }
}
