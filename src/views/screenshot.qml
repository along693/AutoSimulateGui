import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Window 2.14
import QtQuick.Dialogs

Window {
    id: root

    property var pixmap: null
    readonly property int borderMargin: 3
    readonly property color tranparentColor: "transparent"       //透明色
    readonly property color blurryColor: Qt.rgba(0,0,0,0.3)      //模糊色
    readonly property color selectBorderColor: "green"           //边框色

    signal  sigClose()

    color: tranparentColor
    visibility: ApplicationWindow.FullScreen
    flags: Qt.FramelessWindowHint

    //四个阴影区域，笼罩未选择区域
    //一个选择区域
    Rectangle{
        id: topRect
        anchors{
            top: parent.top
            left: parent.left
        }
        width: parent.width
        height: selectionRect.y
        color: blurryColor
    }

    Rectangle{
        id: leftRect
        anchors{
            top: topRect.bottom
            left: parent.left
        }
        width: selectionRect.x
        height: parent.height - topRect.height - bottomRect.height
        color: blurryColor
    }

    Rectangle{
        id: rightRect
        anchors{
            top: topRect.bottom
            right: parent.right
        }
        width: parent.width - leftRect.width - selectionRect.width
        height: leftRect.height
        color: blurryColor
    }

    Rectangle{
        id: bottomRect
        anchors{
            bottom: parent.bottom
            left: parent.left
        }
        width: parent.width
        height: parent.height - topRect.height - selectionRect.height
        color: blurryColor
    }

    MouseArea {
        id: mainMouseArea
        anchors.fill: parent
        property int startX: 0
        property int startY: 0
        property int endX: 0
        property int endY: 0

        onPressed: function (mouse){
            startX = mouse.x;
            startY = mouse.y;
            selectionRect.width = 0;
            selectionRect.height = 0;
            selectionRect.visible = true;
        }
        onPositionChanged: function (mouse){
            if (pressed) {
                endX = mouse.x;
                endY = mouse.y;
                selectionRect.width = Math.abs(endX - startX);
                selectionRect.height = Math.abs(endY - startY);
                selectionRect.x = Math.min(startX, endX);
                selectionRect.y = Math.min(startY, endY);
            }
        }
        onReleased: function (mouse){
            selectionRect.updateStartAndEndPoint();
            functionRect.visible = true;
        }
    }

    Rectangle {
        id: selectionRect

        property var startPoint
        property var endPoint

        function updateStartAndEndPoint() {
            startPoint = Qt.point(x, y);
            endPoint = Qt.point(x + width, y + height);
        }

        visible: false
        border.color: selectBorderColor
        border.width: 1
        color: tranparentColor

        MouseArea {
            id: dragItem
            anchors.fill: parent
            anchors.margins: 12 * 2
            cursorShape: Qt.SizeAllCursor
            drag.target: parent
            onPositionChanged: {
                selectionRect.updateStartAndEndPoint();
            }
        }

        Item{
            id: resizeBorderItem
            anchors.centerIn: parent
            width: parent.width + borderMargin * 2
            height: parent.height + borderMargin * 2
        }

        //LeftTop
        CusDragRect{
            id: dragLeftTop
            anchors{
                left: resizeBorderItem.left
                top: resizeBorderItem.top
            }
            visible: selectionRect.visible
            callBackFunc : selectionRect.updateStartAndEndPoint
            posType: posLeftTop

            onSigPosChanged: function(mousePoint){
                var point = mapToGlobal(mousePoint);
                selectionRect.x = Math.min(point.x, selectionRect.endPoint.x);
                selectionRect.y = Math.min(point.y, selectionRect.endPoint.y);
                selectionRect.width = Math.max(selectionRect.endPoint.x, point.x)  - selectionRect.x;
                selectionRect.height = Math.max(selectionRect.endPoint.y, point.y) - selectionRect.y;
            }
        }

        //LeftBottom
        CusDragRect{
            id: dragLeftBottom
            anchors{
                left: resizeBorderItem.left
                bottom: resizeBorderItem.bottom
            }
            visible: selectionRect.visible
            callBackFunc : selectionRect.updateStartAndEndPoint
            posType: posLeftBottom

            onSigPosChanged: function(mousePoint){
                var point = mapToGlobal(mousePoint);
                selectionRect.x = Math.min(point.x, selectionRect.endPoint.x);
                selectionRect.y = Math.min(point.y, selectionRect.startPoint.y);
                selectionRect.width = Math.max(selectionRect.endPoint.x, point.x)  - selectionRect.x;
                selectionRect.height = Math.max(selectionRect.startPoint.y, point.y) - selectionRect.y;
            }
        }

        //RightTop
        CusDragRect{
            id: dragRightTop
            anchors{
                right: resizeBorderItem.right
                top: resizeBorderItem.top
            }
            visible: selectionRect.visible
            callBackFunc : selectionRect.updateStartAndEndPoint
            posType: posRightTop

            onSigPosChanged: function(mousePoint){
                var point = mapToGlobal(mousePoint);
                selectionRect.x = Math.min(point.x, selectionRect.startPoint.x);
                selectionRect.y = Math.min(point.y, selectionRect.endPoint.y);
                selectionRect.width = Math.max(selectionRect.startPoint.x, point.x)  - selectionRect.x;
                selectionRect.height = Math.max(selectionRect.endPoint.y, point.y) - selectionRect.y;
            }
        }

        //RightBottom
        CusDragRect{
            id: dragRightBottom
            anchors{
                right: resizeBorderItem.right
                bottom: resizeBorderItem.bottom
            }
            visible: selectionRect.visible
            callBackFunc : selectionRect.updateStartAndEndPoint
            posType: posRightBottom

            onSigPosChanged: function(mousePoint){
                var point = mapToGlobal(mousePoint);
                selectionRect.x = Math.min(point.x, selectionRect.startPoint.x);
                selectionRect.y = Math.min(point.y, selectionRect.startPoint.y);
                selectionRect.width = Math.max(selectionRect.startPoint.x, point.x)  - selectionRect.x;
                selectionRect.height = Math.max(selectionRect.startPoint.y, point.y) - selectionRect.y;
            }
        }

        //Top
        CusDragRect{
            id: dragTop
            anchors{
                top: resizeBorderItem.top
                horizontalCenter: resizeBorderItem.horizontalCenter
            }
            visible: selectionRect.visible
            callBackFunc : selectionRect.updateStartAndEndPoint
            posType: posTop

            onSigPosChanged: function(mousePoint){
                var point = mapToGlobal(mousePoint);
                selectionRect.y = Math.min(point.y, selectionRect.endPoint.y);
                selectionRect.height = Math.max(selectionRect.endPoint.y, point.y) - selectionRect.y;
            }
        }

        //Bottom
        CusDragRect{
            id: dragBottom
            anchors{
                bottom: resizeBorderItem.bottom
                horizontalCenter: resizeBorderItem.horizontalCenter
            }
            visible: selectionRect.visible
            callBackFunc : selectionRect.updateStartAndEndPoint
            posType: posBottom

            onSigPosChanged: function(mousePoint){
                var point = mapToGlobal(mousePoint);
                selectionRect.y = Math.min(point.y, selectionRect.startPoint.y);
                selectionRect.height = Math.max(selectionRect.startPoint.y, point.y) - selectionRect.y;
            }
        }

        //Left
        CusDragRect{
            id: dragLeft
            anchors{
                left: resizeBorderItem.left
                verticalCenter: resizeBorderItem.verticalCenter
            }
            visible: selectionRect.visible
            callBackFunc : selectionRect.updateStartAndEndPoint
            posType: posLeft

            onSigPosChanged: function(mousePoint){
                var point = mapToGlobal(mousePoint);
                selectionRect.x = Math.min(point.x, selectionRect.endPoint.x);
                selectionRect.width = Math.max(selectionRect.endPoint.x, point.x)  - selectionRect.x;

            }
        }

        //Right
        CusDragRect{
            id: dragRight
            anchors{
                right: resizeBorderItem.right
                verticalCenter: resizeBorderItem.verticalCenter
            }
            visible: selectionRect.visible
            callBackFunc : selectionRect.updateStartAndEndPoint
            posType: posLeft

            onSigPosChanged: function(mousePoint){
                var point = mapToGlobal(mousePoint);
                selectionRect.x = Math.min(point.x, selectionRect.startPoint.x);
                selectionRect.width = Math.max(selectionRect.startPoint.x, point.x)  - selectionRect.x;
            }
        }
    }

    Item{
        id: functionRect
        width: cancelBtn.width + oKBtn.width + 5
        height: cancelBtn.height
        visible: false
        anchors{
            top: selectionRect.bottom
            topMargin: 3
            right:selectionRect.right
        }

        Button{
            id: cancelBtn
            anchors{
                right: oKBtn.left
                verticalCenter: parent.verticalCenter
            }
            text: "退出"
            onClicked: {
                WindowManager.showApplication();
                close();
            }
        }
        FileDialog {
            id: fileDialog
            title: "Save Image"
            nameFilters: ["Images (*.png *.jpg)", "All Files (*)"]
            fileMode: FileDialog.SaveFile
            currentFile: "file:///"+"capture.png"
            defaultSuffix: ".png"
            onAccepted: {
                var filePath = fileDialog.currentFile.toString().substring(8)
                print(filePath)
                WindowManager.showApplication();
                root.close();
                ScreenShot.saveCapture(pixmap, filePath);
            }
        }


        Button{
            id: oKBtn
            anchors{
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            text: "完成"
            onClicked: {
                pixmap = captureScreenshot(selectionRect.x, selectionRect.y, selectionRect.width, selectionRect.height);
                fileDialog.open();
            }
        }
    }

    function captureScreenshot(x, y, width, height) {
        return ScreenShot.captureArea(x, y, width, height);
    }
}

