import QtQuick

Rectangle {
    id: root

    signal clicked

    property alias text: label.text
    CompanionTheme {
        id: theme
    }

    function alpha(c, a) {
        return Qt.rgba(c.r, c.g, c.b, a);
    }

    width: 26
    height: 38
    color: "transparent"
    border.color: alpha(theme.fg, 0.15)
    border.width: 1

    Text {
        id: label
        anchors.centerIn: parent
        font.pixelSize: 18
        color: mouse.containsMouse ? theme.fg : alpha(theme.fg, 0.35)
        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
