import QtQuick 2.8

Rectangle {
    property alias text: txt.text

    height: txt.height
    width: txt.width

    color: "white"
    visible: false
    radius: 4

    Text {
        id: txt

        width: text.length > 50 ? 200 : text.length * font.pointSize

        //style
        padding: 4
        wrapMode: Text.WordWrap
    }
}
