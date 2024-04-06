pragma Singleton
import QtQuick 2.15

QtObject {
    id: style
    // General properties
    property color color1: "#d4eaf7"
    property color color2: "#b6ccd8"
    property color color3: "#3b3c3d"
    property color color4: "#71c4ef"
    property color color5: "#00668c"
    property color color6: "#fffefb"
    property color color7: "#f5f4f1"
    property color color8: "#cccbc8"
    property color color9: "#1d1c1c"
    property color color10: "#313d44"

    property color primaryColor: "#FF5733"
    property color secondaryColor: "#3366FF"
    property color textColor: "#333333"
    property int fontSize: 16

    // Button properties
    property color buttonBackgroundColor: style.primaryColor
    property color buttonTextColor: "white"
    property int buttonCornerRadius: 5

    // TextField properties
    property color textFieldBorderColor: style.secondaryColor
    property color textFieldFocusColor: style.primaryColor
    property color textFieldTextColor: style.textColor
    property int textFieldBorderWidth: 2
}
