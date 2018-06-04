import QtQuick 2.0

import Chest 1.0

ListView {
    //dimension
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
            PasswordManager.removePassword(index);
        }
    }
}
