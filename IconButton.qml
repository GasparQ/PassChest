import QtQuick 2.0

ActionButton {
    property alias icon: _icon

    Image {
        id: _icon

        anchors.centerIn: parent
        source: iconUrl
    }
}
