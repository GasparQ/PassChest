import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.3

import Chest 1.0

import "../components"
import "../model"

Item {
    id: __view__
    anchors.fill: parent

    signal addPassword();
    signal copyPassword(var password);
    signal editPassword(var password);
    signal removePassword(var password);

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
                        __view__.copyPassword(modelData);
                    }

                    onEdit: {
                        __view__.editPassword(modelData);
                    }

                    onRemove: {
                        __view__.removePassword(modelData);
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
                    __view__.addPassword();
                }
            }
        }
    }
}
