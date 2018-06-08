import QtQuick 2.0

ActionButton {
    property alias value: _text

    Text {
        id: _text

        anchors.centerIn: parent
    }
}
