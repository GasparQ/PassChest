import QtQuick 2.8
import QtQuick.Window 2.2

import Chest 1.0

Window {
    visible: true
    width: 400; maximumWidth: 400; minimumWidth: 400;
    height: 600; maximumHeight: 600; minimumHeight: 600;
    title: qsTr("Password Chest")

    Component.onCompleted: {
        if (PasswordManager.lastFileOpened)
        {
            passListView.loadFile(PasswordManager.lastFileOpened);
        }
    }

    Rectangle {
        anchors.fill: parent

        color: "#20304c"

        //view manager
        ViewManager {
            id: passChestView

            AskPasswordView
            {
                id: askPassView
            }

            EditPassView
            {
                id: editPassView
            }

            PassListView
            {
                id: passListView
            }

            views: {
                "askpass": askPassView,
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
