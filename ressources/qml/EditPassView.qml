import QtQuick 2.8

import Chest 1.0

Item {
    property var toEdit: null

    anchors.fill: parent

    onToEditChanged: {
        if (toEdit) {
            _name.text = toEdit.name;
            _description.text = toEdit.description;
            _password.text = "";
            _confirmPassword.text = "";
        }
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
                        toEdit.name = _name.text;
                        toEdit.description = _description.text;
                        if (_password.text)
                            toEdit.setPassword(_password.text);
                        passChestView.url = 'passlist';
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
                if (!toEdit.name || !toEdit.description || !toEdit.hasPassword()) {
                    PasswordManager.removePassword(toEdit.id);
                }
                passChestView.url = 'passlist';
            }
        }
    }
}
