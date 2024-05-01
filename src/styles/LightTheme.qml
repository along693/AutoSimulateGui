pragma Singleton
import QtQuick 2.15

QtObject {
    id: style
    property color color1: "#d4eaf7"
    property color color2: "#b6ccd8"
    property color color3: "#3b3c3d"
    property color color4: "#FFB9DDFF"
    property color color5: "#00668c"
    property color color6: "#fffefb"

    property color buttonCheckedColor: "#FFB9DDFF"
    property color buttonUnCheckedColor: "transparent"
    property color textColor: "#111229"

    property color mainColor: "#FFFFFF"
    property color mainBlueColor: "#124051"
    property color rectangleColor: "#ffffff"
    property alias filenamePanelColor: style.mainColor
    property color lineNumberPanelColor: "#f5f4f1"
    property color lineNumberBackground: "#d3d3d3"
    property color lineNumberSelectedBackgroundColor: "#FFB9DDFF"
    property alias lineNumberCurrentBackgroundColor: style.mainBlueColor
    property color lineNumberSelectedTextColor: "#00619a"
    property color lineNumberCurrentTextColor: "white"
    property alias lineNumberTextColor: style.mainBlueColor
    property font editorFont: Qt.font({family: "Hack", pointSize: 14})
    property font logFont: Qt.font({family: "Hack", pointSize: 10})
}
