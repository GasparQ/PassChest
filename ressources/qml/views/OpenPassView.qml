import QtQuick 2.0
import QtQuick.Controls 1.4

import "../components"

Item {
    id: _askPass

    property alias passError: _passwd.error

    signal confirmed(string password)
    signal canceled()

    function clear() {
        _passwd.text = "";
        _passwd.focus = true;
    }

    Column {
        anchors.centerIn: parent

        anchors.right: parent.right
        anchors.left: parent.left

        spacing: 20

        anchors.margins: 20

        Label {
            anchors.right: parent.right
            anchors.left: parent.left

            text: "Enter your password"

            color: "white"
            font.pointSize: 18

            horizontalAlignment: Label.AlignHCenter
        }

        InputText {
            id: _passwd

            width: 300
            height: 50

            echoMode: TextInput.Password
            passwordCharacter: '*'
            placeholder.text: "Password"

            backgroundColor: Qt.lighter("#557bba")
            color: "white"
            placeholder.color: "ghostwhite"
        }

        TextButton {
            width: 300
            height: 50

            value.text: "OK"

            defaultColor: "#557bba"
            value.color: "white"
            value.font.pointSize: 16

            onReleased: {
                _askPass.confirmed(_passwd.text);
            }
        }

        TextButton {
            width: 300
            height: 50

            value.text: "Cancel"

            defaultColor: "#557bba"
            value.color: "white"
            value.font.pointSize: 16

            onReleased: {
                _askPass.canceled();
            }
        }
    }
}
