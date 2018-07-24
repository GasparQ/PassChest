import QtQuick 2.8
import QtQuick.Window 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import Chest 1.0

import "views"
import "components"
import "utils"

ApplicationWindow {
    id: _win

    visible: true
    width: 400; maximumWidth: 400; minimumWidth: 400;
    height: 600; maximumHeight: 600; minimumHeight: 600;
    title: qsTr("Password Chest")

    Component.onCompleted: {
        if (!PasswordManager.isOpen)
        {
            openPassView.filename = PasswordManager.filename;
            PasswordManager.filename = "";
            passChestView.url = "openpass";
        }
    }

    Action {
        id: newAction
        onTriggered: {
            if (!PasswordManager.isSaved && savePassView.enabled)
                saveAction.trigger();
            PasswordManager.reset();
            passChestView.url = "passlist"
        }
        shortcut: StandardKey.New
    }

    PassFileDialog {
        id: _openDialog
        onAccepted: {
            openPassView.filename = _openDialog.fileUrl.toLocaleString();
            passChestView.url = "openpass"
        }
    }

    Action {
        id: openAction
        onTriggered: _openDialog.open()
        shortcut: StandardKey.Open
    }

    Action {
        id: saveAction
        onTriggered: {
            if (!PasswordManager.filename)
            {
                saveAsAction.trigger();
            }
            else
            {
                savePassView.filename = PasswordManager.filename
                passChestView.url = "savepass"
            }
        }
        shortcut: StandardKey.Save
        enabled: passChestView.url == "passlist"
    }

    PassFileDialog {
        id: _saveDialog
        selectExisting: false
        onAccepted: {
            savePassView.filename = _saveDialog.fileUrl
            passChestView.url = "savepass"
        }
    }

    Action {
        id: saveAsAction
        onTriggered: _saveDialog.open()
        shortcut: StandardKey.SaveAs
        enabled: passChestView.url == "passlist"
    }

    Action {
        id: closeAction
        onTriggered: {
            if (!PasswordManager.isSaved)
                saveAction.trigger();
            _win.close();
        }
        shortcut: StandardKey.Close
    }

    Action {
        id: undoAction
        onTriggered: PasswordManager.undo()
        shortcut: StandardKey.Undo
        enabled: PasswordManager.canUndo
    }

    Action {
        id: redoAction
        onTriggered: PasswordManager.redo()
        shortcut: StandardKey.Redo
        enabled: PasswordManager.canRedo
    }

    Action {
        id: addPassAction
        onTriggered: {
            editPassView.toEdit = null;
            passChestView.url = "editpass";
        }
        shortcut: "Ctrl+A"
        enabled: passChestView.url == "passlist"
    }

    menuBar: MenuBar {
        id: _menubar

        Menu {
            title: qsTr("File")

            MenuItem {
                text: qsTr("New")
                onTriggered: newAction.trigger()
                enabled: newAction.enabled
            }

            MenuItem {
                text: qsTr("Open")
                onTriggered: openAction.trigger()
                enabled: openAction.enabled
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Save")
                onTriggered: saveAction.trigger()
                enabled: saveAction.enabled
            }

            MenuItem {
                text: qsTr("Save as")
                onTriggered: saveAsAction.trigger()
                enabled: saveAsAction.enabled
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Close")
                onTriggered: closeAction.trigger()
                enabled: closeAction.enabled
            }
        }

        Menu {
            title: qsTr("Edit")

            MenuItem {
                text: qsTr("Undo")
                onTriggered: undoAction.trigger()
                enabled: undoAction.enabled
            }

            MenuItem {
                text: qsTr("Redo")
                onTriggered: redoAction.trigger()
                enabled: redoAction.enabled
            }

            MenuSeparator {}

            MenuItem {
                text: qsTr("Add password")
                onTriggered: addPassAction.trigger()
                enabled: addPassAction.enabled
            }
        }
    }

    Rectangle {
        anchors.fill: parent

        color: "#20304c"

        ViewManager {
            id: passChestView

            anchors.fill: parent

            OpenPassView {
                id: openPassView

                anchors.fill: parent

                property string filename

                onConfirmed: {
                    var save = PasswordManager.filename;

                    PasswordManager.filename = filename;
                    if (!PasswordManager.load(password))
                    {
                        PasswordManager.filename = save;
                        passError = "Incorrect password, retry";
                        clear();
                    }
                    else
                    {
                        passError = "";
                        passChestView.url = "passlist";
                    }
                }

                onCanceled: {
                    passError = "";
                    passChestView.url = "passlist";
                }
            }

            SavePassView {
                id: savePassView

                anchors.fill: parent

                property string filename

                onConfirmed: {
                    var save = PasswordManager.filename;

                    PasswordManager.filename = filename;
                    if (!PasswordManager.save(password))
                        PasswordManager.filename = save;
                    passChestView.url = "passlist";
                }

                onCanceled: {
                    passError = "";
                    passChestView.url = "passlist"
                }
            }

            EditPassView {
                id: editPassView

                anchors.fill: parent

                property var toEdit: null

                passwordOptionnal: toEdit != null

                onToEditChanged: {
                    clear();
                    if (toEdit) {
                        name.text = toEdit.name;
                        description.text = toEdit.description;
                    }
                }

                onConfirmed: {
                    if (toEdit)
                        PasswordManager.editPassword(toEdit.id, name, description, password);
                    else
                        PasswordManager.addPassword(name, description, password);
                    toEdit = null;
                    passChestView.url = 'passlist';
                }

                onCanceled: {
                    if (!toEdit.name || !toEdit.description || !toEdit.hasPassword()) {
                        PasswordManager.removePassword(toEdit.id); //new password canceling
                    }
                    passChestView.url = 'passlist';
                }
            }

            PassListView {
                id: passListView

                anchors.fill: parent

                onAddPassword: {
                    addPassAction.trigger();
                }

                onCopyPassword: {
                    password.copyToClipboard();
                }

                onEditPassword: {
                    editPassView.toEdit = password;
                    passChestView.url = "editpass";
                }

                onRemovePassword: {
                    PasswordManager.removePassword(password.id);
                }
            }

            views: {
                "openpass": openPassView,
                "savepass": savePassView,
                "editpass": editPassView,
                "passlist": passListView
            }
            url: "passlist"
        }
    }

    //tooltip window
    Tooltip {
        id: tooltip
    }
}
