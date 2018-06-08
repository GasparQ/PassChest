import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

import Chest 1.0

Item {
    anchors.fill: parent

    Column {
        anchors.fill: parent

        Rectangle {
            height: parent.height - _listActions.height
            width: parent.width

            color: "transparent"

            ListView {
                id: _passlist

                anchors.fill: parent

                //style

                //data
                model: PasswordManager.passwords
                delegate: Pass {
                    name: modelData.name
                    description: modelData.description

                    onCopyToClipboard: {
                        modelData.copyToClipboard();
                    }

                    onEdit: {
                        passChestView.views['editpass'].toEdit = modelData;
                        passChestView.url = 'editpass';
                    }

                    onRemove: {
                        PasswordManager.removePassword(modelData.id);
                    }
                }
            }
        }

        Row {
            id: _listActions

            width: parent.width
            height: 100

            IconButton {
                id: _addButton

                width: parent.width / parent.children.length
                height: parent.height

                icon.source: "/icons/add.png"

                defaultColor: "#20304c"
                border.color: "white"

                onReleased: {
                    passChestView.views["editpass"].toEdit = PasswordManager.newPassword();
                    passChestView.url = "editpass";
                }
            }

            IconButton {
                id: _saveButton

                width: parent.width / parent.children.length
                height: parent.height

                icon.source: "/icons/save.png"

                defaultColor: "#20304c"
                border.color: "white"

                onReleased: {
                    _saveDiag.visible = true;
                }

                FileDialog {
                    id: _saveDiag

                    title: "Choose a location"
                    selectExisting: false
                    selectMultiple: false
                    selectFolder: false

                    onAccepted: {
                        PasswordManager.save(_saveDiag.fileUrl)
                    }
                }
            }

            IconButton {
                id: _loadButton

                width: parent.width / parent.children.length
                height: parent.height

                icon.source: "/icons/load.png"

                defaultColor: "#20304c"
                border.color: "white"

                onReleased: {
                    _loadDiag.visible = true;
                }

                FileDialog {
                    id: _loadDiag

                    title: "Choose a file"
                    selectExisting: true
                    selectMultiple: false
                    selectFolder: false

                    onAccepted: {
                        PasswordManager.load(_loadDiag.fileUrl, "");
                    }
                }
            }
        }
    }
}
