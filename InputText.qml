import QtQuick 2.8

TextInput {
    id: _val

    property alias placeholder: _placeholder.text

    clip: true

    font.pointSize: 12
    padding: 10

    Rectangle {
        anchors.fill: parent
        color: "white"
        z: parent.z - 1
    }

    Text {
        id: _placeholder

        anchors.centerIn: parent

        font.pointSize: 12

        color: "grey"

        visible: _val.length === 0
    }
}
