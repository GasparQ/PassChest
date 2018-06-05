import QtQuick 2.0
import QtQuick.Controls 1.4

import Chest 1.0

Item {
    anchors.fill: parent

    Column {
        anchors.fill: parent

        Rectangle {
            height: parent.height - _addButton.height
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

        IconButton {
            id: _addButton

            icon.source: "icons/add.png"
            icon.horizontalAlignment: Image.AlignHCenter

            defaultColor: "#20304c"

            height: 100
            width: parent.width

            onReleased: {
                passChestView.views["editpass"].toEdit = PasswordManager.newPassword();
                passChestView.url = "editpass";
            }
        }
    }
}
