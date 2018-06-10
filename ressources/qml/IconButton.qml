import QtQuick 2.0

ActionButton {
    property alias icon: _icon

    defaultColor: "transparent"

    Image {
        id: _icon

        anchors.centerIn: parent
        source: iconUrl

        horizontalAlignment: Image.AlignHCenter
    }
}
