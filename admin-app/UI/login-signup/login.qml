import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import "../qmlComponets"
import "../../"

Item {
    width: 1366
    height: 768
    signal setQMLSource(string path)
    function signUpAccount(){
        if(sql.validateUsernameSignUp(sUsernameField.text) === 1){
            if(sql.checkUsernameExist(sUsernameField.text) === 1){
                if(sql.validatePasswordSignUp(sPasswordField.text) === 1){
                    if(sql.passMatch(sPasswordField.text,confirmPasswordField.text)===1){
                        sql.createUser(sUsernameField.text + "," + sql.hashPass(sPasswordField.text) + ",1,0","")
                        sUsernameField.text = ""
                        sPasswordField.text = ""
                        confirmPasswordField.text = ""
                        errorSignup.text = ""
                    }else{
                        errorSignup.text = "*passwords do not match"
                    }
                }else{
                    errorSignup.text = "*the password must be 8-16 characters, must contain atleast 1 alphabet, specialcharacter and number"
                }
            }else{
                errorSignup.text = "*username already exists"
            }
        }else{
            errorSignup.text = "*username should be atleast 6 characters"
        }
    }
    function loginAccount(){
        if (sql.loginUser(usernameField.text,passwordField.text)===1){

            operatorDetails.json = sql.getUser("*","username",usernameField.text)
            Style.username = operatorDetails.mo[0].username
            Style.photo = operatorDetails.mo[0].profileImage
            if(operatorDetails.mo[0].admin==="1"){
                Style.admin = 1
            }else{
                Style.admin = 0
            }

            setQMLSource("UI/dashboard/dashboard.qml")

        } else {
            errorLogin.text = "*the login credentials do not match our records."
        }
    }
    JSONListModel{
        id: operatorDetails
        json: ""
    }
    Rectangle {
        y: 35
        id: mainContainer
        Image {
            id: backgroundimage
            x: 0
            fillMode: Image.PreserveAspectFit
            source: "image-assets/background.png"

            Rectangle {
                id: loginBox
                x: 152
                y: 157
                width: 499
                height: 507
                color: Style.mainColor
                opacity: 0.95

                Text {
                    id: errorLogin
                    x: 45
                    y: 150
                    width: 411
                    height: 18
                    text: ""
                    color: "#ff0000"
                    smooth: true
                    font.pointSize: 11
                }
                Image {
                    id: image
                    x: 160
                    y: 34
                    width: 179
                    height: 74
                    fillMode: Image.PreserveAspectFit
                    source: "image-assets/logo.png"
                }

                TextField {
                    id: usernameField
                    x: 45
                    y: 176
                    width: 411
                    height: 54
                    text: qsTr("")
                    color: "#ffffff"
                    font.pointSize: 15
                    placeholderText: "Username"
                    placeholderTextColor: "#707987"
                }
                TextField {
                    id: passwordField
                    x: 45
                    y: 277
                    width: 411
                    height: 54
                    text: qsTr("")
                    color: "#ffffff"
                    font.pointSize: 15
                    placeholderText: "Password"
                    placeholderTextColor: "#707987"
                    echoMode: TextInput.Password
                    Keys.onReturnPressed: loginButton.clicked()
                    Keys.onEnterPressed: loginButton.clicked()
                }

                Button {
                    id: loginButton
                    x: 150
                    y: 368
                    width: 199
                    height: 65
                    text: qsTr("Login")
                    font.pointSize: 16
                    focus: true
                    onClicked: {
                        loginAccount()
                    }
                    Material.background: "#ff704b"

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            parent.state = 'Hovering'
                        }
                        onExited: {
                            parent.state = ''
                        }
                        onClicked: {
                            parent.clicked()
                        }
                        onPressed: {
                            parent.state = "Pressed"
                        }
                        onReleased: {
                            if (containsMouse)
                                parent.state = "Hovering"
                            else
                                parent.state = ""
                        }
                    }
                    Loader {
                        id: ld
                        anchors.fill: parent
                    }
                }

                Text {
                    id: createAccountLink
                    x: 185
                    y: 457
                    width: 129
                    height: 17
                    color: "#707987"
                    text: qsTr("Create an Account")
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16
                    MouseArea {
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            parent.color = "#ffffff"
                        }
                        onExited: {
                            parent.color = "#707987"
                        }
                        onClicked: {
                            loginBox.visible = false
                            signupBox.visible = true
                        }
                    }
                }
            }

            Rectangle {
                id: signupBox
                x: 715
                y: 157
                width: 499
                visible: false
                height: 507
                color: Style.mainColor
                opacity: 0.95


                Text {
                    id: errorSignup
                    x: 46
                    y: 125
                    width: 411
                    height: 42
                    color: "#ff0000"
                    wrapMode: Text.WordWrap
                    smooth: true
                    font.pointSize: 11
                }

                Image {
                    id: signupimage
                    x: 160
                    y: 34
                    width: 179
                    height: 74
                    fillMode: Image.PreserveAspectFit
                    source: "image-assets/logo.png"
                }

                TextField {
                    id: sUsernameField
                    x: 46
                    y: 178
                    width: 411
                    height: 54
                    color: "#ffffff"
                    font.pointSize: 15
                    placeholderText: "Username"
                    placeholderTextColor: "#707987"
                }

                TextField {
                    id: sPasswordField
                    x: 46
                    y: 248
                    width: 411
                    height: 54
                    text: qsTr("")
                    color: "#ffffff"
                    font.pointSize: 15
                    echoMode: TextInput.Password
                    placeholderText: "Password"
                    placeholderTextColor: "#707987"
                }

                TextField {
                    id: confirmPasswordField
                    x: 46
                    y: 318
                    width: 411
                    height: 54
                    text: qsTr("")
                    color: "#ffffff"
                    font.pointSize: 15
                    echoMode: TextInput.Password
                    placeholderText: "Confirm Password"
                    placeholderTextColor: "#707987"
                    Keys.onReturnPressed: signupButton.clicked()
                    Keys.onEnterPressed: signupButton.clicked()
                }

                Button {
                    id: signupButton
                    x: 150
                    y: 378
                    width: 199
                    height: 65
                    text: qsTr("Signup")
                    font.pointSize: 16
                    onClicked: {
                        signUpAccount()
                    }
                    Material.background: "#ff704b"
                    focusPolicy: Qt.NoFocus

                    states: [
                        State {
                            name: "Hovering"
                            PropertyChanges {
                                target: signupButton
                            }
                        },
                        State {
                            name: "Pressed"
                            PropertyChanges {
                                target: signupButton
                            }
                        }
                    ]

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            parent.state = 'Hovering'
                        }
                        onExited: {
                            parent.state = ''
                        }
                        onClicked: {
                            parent.clicked()
                        }
                        onPressed: {
                            parent.state = "Pressed"
                        }
                        onReleased: {
                            if (containsMouse)
                                parent.state = "Hovering"
                            else
                                parent.state = ""
                        }
                    }
                }

                Text {
                    id: signupAccountLink
                    x: 126
                    y: 457
                    width: 248
                    height: 17
                    color: "#707987"
                    text: qsTr("Already Have An Account? | Login")
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 16

                    MouseArea {
                        id: signMArea
                        hoverEnabled: true
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onEntered: {
                            parent.color = "#ffffff"
                        }
                        onExited: {
                            parent.color = "#707987"
                        }
                        onClicked: {
                            loginBox.visible = true
                            signupBox.visible = false
                        }
                    }
                }
            }
        }
    }
}
