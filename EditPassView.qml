import QtQuick 2.8

Item {
    property var toEdit: null

    anchors.fill: parent

    onToEditChanged: {
        if (toEdit) {
            _name.text = toEdit.name;
            _description.text = toEdit.description;
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
        }

        InputText {
            id: _description

            width: 300
            height: 50
        }

        InputText {
            id: _password

            width: 300
            height: 50

            echoMode: TextInput.Password
            passwordCharacter: '*'
            placeholder: "Left empty for no change"
        }

        Rectangle {
            id: _validate
            width: 300
            height: 50

            color: "white"

            Text {
                anchors.centerIn: parent

                text: "Valider"
                font.pointSize: 16
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    if (!toEdit) {
                        console.error('You cannot edit empty password (toEdit is ', toEdit, ')');
                    }
                    else {
                        toEdit.name = _name.text;
                        toEdit.description = _description.text;
                        if (_password.text)
                            toEdit.setPassword(_password.text);
                        passChestView.url = 'passlist';
                    }
                }
            }
        }

        Rectangle {
            width: 300
            height: 50

            color: "white"

            Text {
                anchors.centerIn: parent
                text: "Annuler"

                font.pointSize: 16
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    passChestView.url = 'passlist';
                }
            }
        }
    }
}
