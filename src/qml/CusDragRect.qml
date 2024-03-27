import QtQuick 2.15

Rectangle {
    id: root

    //5.10之前, qml是不能定义枚举的，用只读的int属性代替一下。
    readonly property int posLeftTop: Qt.SizeFDiagCursor
    readonly property int posLeft: Qt.SizeHorCursor
    readonly property int posLeftBottom: Qt.SizeBDiagCursor
    readonly property int posTop: Qt.SizeVerCursor
    readonly property int posBottom: Qt.SizeVerCursor
    readonly property int posRightTop: Qt.SizeBDiagCursor
    readonly property int posRight: Qt.SizeHorCursor
    readonly property int posRightBottom: Qt.SizeFDiagCursor

    property int posType: Qt.ArrowCursor
    property var callBackFunc

    signal sigPosChanged(var mousePoint)

    border.color: "green"
    border.width: 1
    color: "green"
    width: 3 * 2
    height: width
    radius: width / 2

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: {
            if (containsMouse) {
                cursorShape = posType;
            } else {
                cursorShape = Qt.ArrowCursor;
            }
        }
        onPositionChanged: {
            if (pressed)
                sigPosChanged(Qt.point(mouseX, mouseY));
        }
        onReleased: {
            callBackFunc();
        }
    }
}
