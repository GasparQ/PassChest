import QtQuick 2.8
import QtQuick.Window 2.2

Window {
    visible: true
    width: 400; maximumWidth: 400; minimumWidth: 400;
    height: 600; maximumHeight: 600; minimumHeight: 600;
    title: qsTr("Password Chest")

    Rectangle {
        anchors.fill: parent

        color: "#20304c"

        //view manager
        ViewManager {
            id: passChestView

            views: {
                "passlist": "PassListView.qml",
                "editpass": "EditPassView.qml"
            }
            url: "passlist"
        }
    }

    //tooltip window
    Tooltip {
        id: tooltip
    }
}
