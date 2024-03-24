import QtQuick 2.15
import FluentUI
import QtQuick.Controls 2.15

Item{
    FluScrollablePage{
        width: parent.width*0.815
        height: parent.height
        id: event_timeline
        ListModel{
            id:list_model
            ListElement{
                lable:"test1"
                text:"dasdda"
            }
            ListElement{
                lable:"test2"
                text:"parse 2"
            }
            ListElement{
                lable:"test2"
                text:"parse 2"
            }
            ListElement{
                lable:"test2"
                text:"parse 2"
            }
            ListElement{
                lable:"test2"
                text:"parse 2"
            }
        }
        FluTimeline{
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
