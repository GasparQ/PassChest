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
                var pass = _passwd.text;
                var confirmPass = _confirmPasswd.text;

                _passwd.text = "";
                _passwd.focus = true;

                _confirmPasswd.text = "";
                _confirmPasswd.focus = false;

                _passwd.error = "";
                _confirmPasswd.error = "";

                if (!pass)
                {
                    _passwd.error = "This field cannot be empty"
                }

                if (!confirmPass)
                {
                    _confirmPasswd.error = "This field cannot be empty"
                }

                if (pass && confirmPass)
                {
                    _confirmPasswd.error = "Passwords must be identical"
                }

                if (pass && confirmPass && pass === confirmPass)
                {
                    if (_askPass.onConfirmed)
                        _askPass.onConfirmed(pass);
                }

                pass = ""
                confirmPass = ""
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
