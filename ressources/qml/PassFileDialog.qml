import QtQuick 2.0
import QtQuick.Dialogs 1.3

FileDialog {
    selectMultiple: false
    selectFolder: false
    defaultSuffix: ".pass"
    nameFilters: [ "Password files (*.pass)" ]
}
