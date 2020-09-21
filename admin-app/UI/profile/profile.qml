import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0
import "../qmlComponets"
import "../../"

Item {
    width: 1250
    height: 733
    property string itemImage: ""
    property int hasfile: 0
    property int passChange: 0
    signal setQMLSources(string path)
    Material.accent: Style.accentColor


    function editUser(){
        usernameText.readOnly = false
        imageFilePath.visible = true
        changePasswordText.visible = true
        addImageButton.visible = true
        addImageButtonImage.visible = true
        clearUserButton.visible = true
        saveUserButton.visible = true
    }
    function editRestro(){
        nameText.readOnly = false
        contactText.readOnly = false
        panNoText.readOnly = false
        addressText.readOnly = false
        serviceText.readOnly = false
        vatText.readOnly = false
        clearRestroButton.visible = true
        saveRestroInfoButton.visible = true
    }

    function validateUpdateUsername(){
        if(sql.checkUsernameExist(usernameText.text) === 1){
            if(sql.validateUsernameSignUp(usernameText.text) === 1){
                return 1;
            }else{
                errorUpdate.text = "*username should be atleast 6 characters"
                return 0
            }
        }else{
            errorUpdate.text = "*username already exists"
            return 0
        }
    }

    function validateUpdatePassword(){
        if(passChange == 1){
            if(sql.validatePasswordSignUp(passwordText.text)===1){
                if(sql.passMatch(passwordText.text,confirmPasswordText.text)===1){
                    return 1
                }else{
                    errorUpdate.text = "passwords do not match"
                    return 0
                }
            }else{
                errorUpdate.text = "the password must be 8-16 characters, must contain atleast 1 alphabet, specialcharacter and number"
                return 0
            }
        }else{
            return 1
        }
    }

    Rectangle {
        x: 0
        y: 0
        width: 1268
        height: 752
        color: Style.backgroundColor
        radius: 25
        smooth: true

        JSONListModel {
            id: restaurantModel
            json: sql.getRestaurant()
        }


        JSONListModel {
            id: userModel
            json: sql.getUser("*","username",Style.username)
        }

        Component.onCompleted: {
            nameText.text = restaurantModel.mo[0].name
            addressText.text = restaurantModel.mo[0].address
            panNoText.text = restaurantModel.mo[0].panNo
            contactText.text = restaurantModel.mo[0].contactNo
            vatText.text = restaurantModel.mo[0].vat
            serviceText.text = restaurantModel.mo[0].serviceCharge
            itemImage = userModel.mo[0].profileImage
            usernameText.text = userModel.mo[0].username
        }
        Rectangle {
            id: userDetails
            x: 75
            y: 63
            width: 543
            height: 626
            Text {
                id: info1
                x: 17
                y: 13
                height: 31
                text: qsTr("User Info")
                font.pixelSize: 26
                smooth: true
            }

            Image {
                id: infoLine1
                x: 17
                y: 50
                width: 450
                height: 3
                source: "image-assets/line.png"
                fillMode: Image.Stretch
            }

            Image {
                id: userinfoEdit
                x: 432
                y: 13
                smooth: true
                source: "image-assets/edit.png"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onEntered: parent.source = "image-assets/editHover.png"
                    onExited: parent.source = "image-assets/edit.png"
                    hoverEnabled: true
                    onClicked: {
                        editUser()
                    }
                }
            }

            Rectangle{
                x: 130
                y: 69
                width: 225
                height: 225
                clip: true
                radius: 100
                Image{
                    anchors.fill: parent
                    id: profilePicture
                    layer.enabled: true
                    layer.effect: OpacityMask{maskSource:parent}
                    smooth: true
                    Component.onCompleted: {
                        if (itemImage === "") {
                            source = "../../resources/user.png"
                        } else {
                            source = "data:image/jpeg;base64," + itemImage
                        }
                    }
                }
            }

            Text {
                id: imageFilePath
                x: 130
                y: 300
                width: 208
                height: 31
                text: "No Image Selected"
                visible: false
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#707987"
                font.pixelSize: 14
                elide: Text.ElideRight
            }

            Rectangle{
                visible: false
                id: addImageButton
                x: 306
                y: 251
                width: 30
                height: 30
                opacity: 0.8
                radius: 15
                color: "#ffffff"
            }

            Image {
                id: addImageButtonImage
                x: 306
                y: 251
                width: 30
                height: 30
                smooth: true
                source: "image-assets/plus.png"
                visible: false
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {parent.source = "image-assets/plusHover.png"}
                    onExited: {parent.source = "image-assets/plus.png"}
                    onClicked: fileLoader.source = "file.qml"
                }
            }

            Connections {
                target: fileLoader.item
                onFileDialog:{
                    fileLoader.source=path
                }
                onFilePath:{
                    var filepaths = filePath
                    imageFilePath.text = filepaths.substr(8)
                    hasfile = 1
                }
            }
            Loader {
                id: fileLoader
                source: ""
            }

            Text {
                id: errorUpdate
                x: 30
                y: 337
                width: 378
                height: 53
                text: ""
                color: "#ff0000"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
                smooth: true
            }

            Text {
                id: usernameHook
                x: 30
                y: 406
                text: qsTr("Username")
                font.pixelSize: 20
                smooth: true
            }

            TextField {
                id: usernameText
                x: 158
                y: 396
                width: 250
                height: 50
                font.pixelSize: 20
                smooth: true
                readOnly: true
            }

            Text {
                id: passwordHook
                x: 30
                y: 464
                width: 122
                height: 25
                text: qsTr("Password")
                font.pixelSize: 20
                smooth: true
            }

            TextField {
                id: passwordText
                x: 158
                y: 455
                width: 250
                height: 50
                text: " **********"
                font.pixelSize: 20
                smooth: true
                echoMode: TextInput.Password
                readOnly: true
            }
            Text{
                id: changePasswordText
                x: 354
                y: 498
                width: 46
                height: 22
                text: "change"
                font.pointSize: 10
                color: "#003049"
                font.underline: true
                visible: false
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        passwordText.readOnly = false
                        passwordText.text = ""
                        confirmPasswordHook.visible = true
                        confirmPasswordText.readOnly = false
                        confirmPasswordText.visible = true
                        parent.visible = false
                        passChange = 1
                    }
                }
            }
            Text {
                id: confirmPasswordHook
                x: 30
                y: 535
                width: 160
                height: 25
                font.pixelSize: 20
                text: "Confirm Password"
                smooth: true
                visible: false
            }

            TextField {
                id: confirmPasswordText
                x: 203
                y: 526
                width: 250
                height: 50
                text: ""
                font.pixelSize: 20
                smooth: true
                readOnly: true
                echoMode: TextInput.Password
                visible: false
            }

            Image {
                id: clearUserButton
                x: 360
                y: 576
                source: "image-assets/clear.png"
                smooth: true
                visible: false
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "image-assets/clearHover.png"
                    }
                    onExited: {
                        parent.source = "image-assets/clear.png"
                    }
                    onClicked: {
                        setQMLSources("../profile/profile.qml")
                    }
                }
            }

            Image {
                id: saveUserButton
                x: 429
                y: 576
                source: "image-assets/submit.png"
                smooth: true
                visible: false
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "image-assets/submitHover.png"
                    }
                    onExited: {
                        parent.source = "image-assets/submit.png"
                    }
                    onClicked: {
                        var flag = 0
                        if(Style.username == usernameText.text){
                            flag = 1
                        }
                        if(validateUpdateUsername() === 1 || flag === 1){
                            if(passChange == 1){
                                if(validateUpdatePassword() === 1){
                                    var userData = usernameText.text + "," + sql.hashPass(passwordText.text)
                                    if(hasfile == 1){
                                        sql.updateUser(sql.pkfind("operator","username",Style.username),"username,password", userData, imageFilePath.text)
                                        Style.username = usernameText.text
                                        setQMLSources("../profile/profile.qml")
                                    }else{
                                        sql.updateUser(sql.pkfind("operator","username",Style.username),"username,password", userData)
                                        Style.username = usernameText.text
                                        setQMLSources("../profile/profile.qml")
                                    }
                                }
                            }else{
                                var userData2 = usernameText.text
                                if(hasfile == 1){
                                    sql.updateUser(sql.pkfind("operator","username",Style.username),"username", userData2, imageFilePath.text)
                                    Style.username = usernameText.text
                                    setQMLSources("../profile/profile.qml")
                                }else{
                                    sql.updateUser(sql.pkfind("operator","username",Style.username),"username", userData2)
                                    Style.username = usernameText.text
                                    setQMLSources("../profile/profile.qml")
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: restroDetails
            x: 624
            y: 63
            width: 512
            height: 626
            Text {
                id: info
                x: 17
                y: 13
                height: 31
                smooth: true
                text: qsTr("Restaurant Info")
                font.pixelSize: 26
            }
            Image {
                id: infoLine
                x: 17
                y: 50
                width: 450
                height: 3
                fillMode: Image.Stretch
                source: "image-assets/line.png"
            }
            Image {
                id: infoedit
                x: 438
                y: 13
                fillMode: Image.PreserveAspectFit
                source: "image-assets/edit.png"
                Component.onCompleted: {
                    if(Style.admin == 0){
                        infoedit.visible = false
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onEntered: parent.source = "image-assets/editHover.png"
                    onExited: parent.source = "image-assets/edit.png"
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        editRestro()
                    }
                }
            }
            Text {
                id: nameHook
                x: 27
                y: 74
                smooth: true
                text: qsTr("Name")
                font.pixelSize: 20
            }
            TextField {
                readOnly: true
                id: nameText
                x: 105
                y: 67
                width: 329
                height: 50
                smooth: true
                text: ""
                font.pixelSize: 20
            }
            Text {
                id: contactHook
                x: 27
                y: 141
                width: 135
                height: 25
                smooth: true
                text: qsTr("Contact No")
                font.pixelSize: 20
            }
            TextField {
                readOnly: true
                id: contactText
                x: 174
                y: 134
                width: 260
                height: 50
                smooth: true
                font.pixelSize: 20
            }
            Text {
                id: addressHook
                x: 27
                y: 282
                width: 99
                height: 25
                smooth: true
                text: qsTr("Address")
                font.pixelSize: 20
            }
            TextField {
                readOnly: true
                id: addressText
                x: 132
                y: 275
                width: 302
                height: 50
                smooth: true
                font.pixelSize: 20
            }
            Text {
                id: panNoHook
                x: 27
                y: 215
                width: 71
                height: 24
                smooth: true
                text: qsTr("Pan No")
                font.pixelSize: 20
            }
            TextField {
                readOnly: true
                id: panNoText
                x: 124
                y: 207
                width: 247
                height: 50
                smooth: true
                font.pixelSize: 20
            }
            Text {
                id: vatHook
                x: 27
                y: 354
                width: 44
                height: 24
                smooth: true
                text: qsTr("VAT")
                font.pixelSize: 20
            }
            TextField {
                readOnly: true
                id: vatText
                x: 86
                y: 348
                width: 76
                height: 50
                smooth: true
                font.pixelSize: 20
            }
            Text {
                id: serviceHook
                x: 27
                y: 420
                width: 135
                height: 24
                smooth: true
                text: qsTr("Service Charge")
                font.pixelSize: 20
            }
            TextField {
                readOnly: true
                id: serviceText
                x: 174
                y: 410
                width: 76
                height: 50
                smooth: true
                font.pixelSize: 20
            }
            Image {
                id: clearRestroButton
                x: 369
                y: 493
                source: "image-assets/clear.png"
                smooth: true
                visible: false
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "image-assets/clearHover.png"
                    }
                    onExited: {
                        parent.source = "image-assets/clear.png"
                    }
                    onClicked: {
                        setQMLSources("../profile/profile.qml")
                    }
                }
            }

            Image {
                id: saveRestroInfoButton
                x: 438
                y: 493
                source: "image-assets/submit.png"
                smooth: true
                visible: false
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "image-assets/submitHover.png"
                    }
                    onExited: {
                        parent.source = "image-assets/submit.png"
                    }
                    onClicked: {
                        var data = nameText.text + "," + contactText.text + ","
                                + addressText.text + "," + panNoText.text + "," + serviceText.text + "," + vatText.text
                        sql.updateRestro(restaurantModel.mo[0].id,
                                         "name,contactNo,address,panNO,serviceCharge,vat", data)
                        setQMLSources("../profile/profile.qml")
                    }
                }
            }
        }


    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:1.100000023841858}D{i:11;invisible:true}D{i:12;invisible:true}
D{i:16;invisible:true}D{i:17;invisible:true}D{i:43;invisible:true}D{i:44;invisible:true}
D{i:45;invisible:true}
}
##^##*/
