import QtQuick 2.0
import QtQuick.Dialogs 1.0
FileDialog {
    signal fileDialog(string path)
    signal filePath(string filePath)
    id: imageDialog
    visible: true
    selectMultiple : false
    selectFolder : false
    onAccepted: {
        filePath(imageDialog.fileUrls)
        fileDialog(" ")
    }
    onRejected: {
        fileDialog(" ")
   }
}

