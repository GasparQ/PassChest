import QtQuick 2.8

import Chest 1.0

import "../components"

Item {
    id: __view__

    property alias name: _name
    property alias description: _description

    signal confirmed(string name, string description, string password);
    signal canceled();

    anchors.fill: parent

    function clear() {
        _name.text = "";
        _name.error = "";
        _description.text = "";
        _description.error = "";
        _password.text = "";
        _password.error = "";
        _confirmPassword.text = "";
        _confirmPassword.error = "";
        _name.focus = true;
    }

    Component.onCompleted: {
        clear();
    }

    Column {
        anchors.centerIn: parent

        anchors.right: parent.right
        anchors.left: parent.left

        spacing: 20

        anchors.margins: 20

        InputText {
            id: _name

            width: 300
            height: 50
            placeholder.text: "Name"

            backgroundColor: Qt.lighter("#557bba")
            color: "white"
            placeholder.color: "ghostwhite"
        }

        InputText {
            id: _description

            width: 300
            height: 50
            placeholder.text: "Description"

            backgroundColor: Qt.lighter("#557bba")
            color: "white"
            placeholder.color: "ghostwhite"
        }

        InputText {
            id: _password

            width: 300
            height: 50

            echoMode: TextInput.Password
            passwordCharacter: '*'
            placeholder.text: "Password (empty no change)"

            backgroundColor: Qt.lighter("#557bba")
            color: "white"
            placeholder.color: "ghostwhite"
        }

        InputText {
            id: _confirmPassword

            width: 300
            height: 50

            echoMode: TextInput.Password
            passwordCharacter: '*'
            placeholder.text: "Confirm password"

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
                if (!toEdit) {
                    console.error('You cannot edit empty password (toEdit is ', toEdit, ')');
                }
                else {
                    _name.error = "";
                    _description.error = "";
                    _password.error = "";
                    _confirmPassword.error = "";

                    if (!_name.text) {
                        _name.error = "Field cannot be empty";
                    }

                    if (!_description.text) {
                        _description.error = "Field cannot be empty"
                    }

                    if (!toEdit.hasPassword() && !_password.text) {
                        _password.error = "You have to provide a password";
                    }

                    if (_password.text && _password.text !== _confirmPassword.text) {
                        _confirmPassword.error = "Password and confirmation are different";
                    }

                    if (!_name.error && !_description.error && !_password.error && !_confirmPassword.error) {
                        __view__.confirmed(_name.text, _description.text, _password.text);
                    }
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
                __view__.canceled();
            }
        }
    }
}
