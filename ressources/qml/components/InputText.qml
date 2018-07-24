import QtQuick 2.8

TextInput {
    id: _val

    property alias placeholder: _placeholder
    property alias error: _error.text
    property alias backgroundColor: _background.color

    horizontalAlignment: TextInput.AlignHCenter

    clip: true

    font.pointSize: 12
    padding: 10

    Rectangle {
        id: _background

        anchors.fill: parent
        color: "white"
        z: parent.z - 1
        radius: 5
    }

    Text {
        id: _placeholder

        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        font.pointSize: 10
        color: "lightgrey"
        visible: _val.length === 0
    }

    Text {
        id: _error

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        horizontalAlignment: Text.AlignHCenter

        color: "crimson"
        anchors.bottomMargin: 3
        font.pointSize: 7
    }
}
