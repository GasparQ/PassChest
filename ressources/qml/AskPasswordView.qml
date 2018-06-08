import QtQuick 2.0
import QtQuick.Controls 1.4

Item {
    id: _askPass

    anchors.fill: parent

    property var onConfirmed: null
    property var onCanceled: null

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

        InputText {
            id: _confirmPasswd

            width: 300
            height: 50

            echoMode: TextInput.Password
            passwordCharacter: '*'
            placeholder.text: "Confirm"

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
                _passwd.error = "";
                _confirmPasswd.error = "";

                if (!_passwd.text)
                {
                    _passwd.error = "This field cannot be empty"
                }

                if (!_confirmPasswd.text)
                {
                    _confirmPasswd.error = "This field cannot be empty"
                }

                if (_passwd.text && _confirmPasswd.text)
                {
                    _confirmPasswd.error = "Passwords must be identical"
                }

                if (_passwd.text && _confirmPasswd.text && _passwd.text === _confirmPasswd.text)
                {
                    var pass = _passwd.text;

                    _passwd.text = "";
                    _confirmPasswd.text = "";
                    if (_askPass.onConfirmed)
                        _askPass.onConfirmed(pass);
                }
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
                if (_askPass.onCanceled)
                    _askPass.onCanceled();
            }
        }
    }
}
