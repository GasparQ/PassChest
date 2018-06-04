import QtQuick 2.8
import QtQuick.Window 2.2

import Chest 1.0

Window {
    visible: true
    width: 400
    height: 600
    title: qsTr("Password Chest")

    ListView {
        //dimension
        width: 400
        height: 600

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
                console.log("Edit");
            }

            onRemove: {
                PasswordManager.removePassword(index);
            }
        }
    }

    //tooltip window
    Tooltip {
        id: tooltip
    }
}
