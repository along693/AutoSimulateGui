import QtQuick 2.15
import QtQuick.Window 2.15
import FluentUI
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.platform

FluWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    FluFilledButton{
        text:"Open Screenshot"
        onClicked: {
        screenshot.open()
        }
    }

   Image{
            id:image
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            asynchronous: true
    }
    FluScreenshot{
        id:screenshot
        captrueMode: FluScreenshotType.File
        saveFolder: StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation)+"/screenshot"
        onCaptrueCompleted:
            (captrue)=>{
                print(StandardPaths.writableLocation(StandardPaths.AppLocalDataLocation)+"/screenshot" )
                image.source = captrue
            }
    }

}
