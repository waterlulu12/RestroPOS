import QtQuick 2.0

Item {
    property string json: ""
    property ListModel model: ListModel {
        id: jsonModel
    }
    property int count: 0
    property variant mo: []
    onJsonChanged: updateJSONModel()
    function updateJSONModel() {
        jsonModel.clear()
        if (json === "")
            return

        mo=[]
        var objectArray = JSON.parse(json)
        count = objectArray.length

        for (var key in objectArray) {
            var jo = objectArray[key]
            jsonModel.append(jo)
            mo.push(jo)
        }
    }
}
