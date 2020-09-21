import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import "../../"

Item {
    property int highlighted: 1
    width: 1366
    height: 725
    signal setQMLSource(string path)
    Loader {
        source: "dash.qml"
        width: 1250
        height: 733
        x: 116
        y: 35
        id: insideDashboard
    }
    Connections {
        target: insideDashboard.item
        onSetQMLSources: {
            insideDashboard.source = ""
            insideDashboard.source = path
        }
    }
    Rectangle {
        id: sidebar
        x: -1
        y: 70
        width: 116
        height: 698
        color: Style.mainColor
        smooth: true
        opacity: 1
    }
    Pane {
        id: logoBar
        x: 0
        y: 0
        width: 115
        height: 79
        Material.background: Style.mainColor
    }
    Image {
        id: logo
        source: "image-assets/logo.png"
        x: 14
        y: 22
        width: 87
        height: 35
        opacity: 1
    }
    Rectangle {
        id: highlight
        width: 116
        height: 68
        x: 0
        y: 140
        color: Style.menuHighlight
        opacity: 0.3
    }
    function moveHighlight(changeImg,changeText) {
        dashboardlogo.source = "image-assets/dashboard.png"
        dashboardText.color = Style.menuText
        menulogo.source = "image-assets/burger.png"
        menuText.color = Style.menuText
        profilelogo.source = "image-assets/user.png"
        profileText.color = Style.menuText
        billinglogo.source = "image-assets/bill.png"
        billingText.color = Style.menuText
        statslogo.source = "image-assets/ledger.png"
        statsText.color = Style.menuText
        var s = String(changeImg.source).substr(18)
        var source = s.split(".");
        changeImg.source = source[0] + "Hover." + source[1]
        changeText.color = Style.accentColor

    }
    Item {
        id: dashboardbar
        x: 0
        y: 140
        width: 116
        height: 68

        Image {
            id: dashboardlogo
            source: "image-assets/dashboardHover.png"
            x: 37
            y: 9
            width: 42
            height: 38
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: dashboardText
            x: 29
            y: 54
            width: 58
            height: 14
            color: Style.accentColor
            text: qsTr("Dashboard")
            smooth: true
            font.pixelSize: 12
        }

        MouseArea {
            id: dashboardMArea
            antialiasing: false
            anchors.leftMargin: 0
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                if(String(dashboardlogo.source).search("Hover") === -1){
                    dashboardlogo.source = "image-assets/dashboardHover.png"
                    dashboardText.color = Style.accentColor
                }
            }
            onExited: {
                if(highlighted != 1){
                    dashboardlogo.source = "image-assets/dashboard.png"
                    dashboardText.color = Style.menuText
                }
            }
            onClicked: {
                moveHighlight(dashboardlogo,dashboardText)
                highlighted = 1
                insideDashboard.source = "dash.qml"
            }
            cursorShape: Qt.PointingHandCursor
        }


    }
    Item {
        id: menubar
        x: 0
        y: 240
        width: 116
        height: 68

        Image {
            id: menulogo
            source: "image-assets/burger.png"
            x: 37
            y: 8
            width: 42
            height: 42
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: menuText
            x: 43
            y: 52
            width: 31
            height: 14
            color: Style.menuText
            text: qsTr("Menu")
            smooth: true
            font.pixelSize: 12
        }

        MouseArea {
            id: menuMArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                if(String(menulogo.source).search("Hover") === -1){
                    menulogo.source = "image-assets/burgerHover.png"
                    menuText.color = Style.accentColor
                }
            }
            onExited: {
                if(highlighted !=2){
                    menulogo.source = "image-assets/burger.png"
                    menuText.color = Style.menuText
                }
            }
            onClicked: {
                moveHighlight(menulogo,menuText)
                highlighted = 2
                insideDashboard.source = "../menu/menu.qml"
            }
            cursorShape: Qt.PointingHandCursor
        }



    }
    Item {
        id: profilebar
        x: 0
        y: 340
        width: 116
        height: 68

        Image {
            id: profilelogo
            source: "image-assets/user.png"
            x: 37
            y: 5
            width: 35
            height: 48
            fillMode: Image.PreserveAspectCrop
        }

        Text {
            id: profileText
            x: 37
            y: 54
            width: 37
            height: 14
            color: Style.menuText
            text: qsTr("Profile")
            smooth: true
            font.pixelSize: 12
        }

        MouseArea {
            id: profileMArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                if(String(profilelogo.source).search("Hover") === -1){
                    profilelogo.source = "image-assets/userHover.png"
                    profileText.color = Style.accentColor
                }
            }
            onExited: {
                if(highlighted !=3){
                    profilelogo.source = "image-assets/user.png"
                    profileText.color = Style.menuText
                }
            }
            onClicked: {
                moveHighlight(profilelogo,profileText)
                highlighted = 3
                insideDashboard.source = "../profile/profile.qml"
            }
            cursorShape: Qt.PointingHandCursor
        }



    }
    Item {
        id: billingbar
        x: 0
        y: 440
        width: 116
        height: 68

        Image {
            id: billinglogo
            source: "image-assets/bill.png"
            x: 37
            y: 5
            width: 42
            height: 40
            fillMode: Image.PreserveAspectFit
        }
        Text {
            id: billingText
            x: 39
            y: 48
            width: 34
            height: 14
            color: Style.menuText
            text: qsTr("Billing")
            smooth: true
            font.pixelSize: 12
        }

        MouseArea {
            id: billingMArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                if(String(billinglogo.source).search("Hover") === -1){
                    billinglogo.source = "image-assets/billHover.png"
                    billingText.color = Style.accentColor
                }
            }
            onExited: {
                if(highlighted !=4){
                    billinglogo.source = "image-assets/bill.png"
                    billingText.color = Style.menuText
                }
            }
            onClicked: {
                moveHighlight(billinglogo,billingText)
                highlighted = 4
                insideDashboard.source = "../billing/billing.qml"
            }
            cursorShape: Qt.PointingHandCursor
        }



    }
    Item {
        id: statsbar
        x: 0
        y: 540
        width: 116
        height: 68

        Image {
            id: statslogo
            source: "image-assets/ledger.png"
            x: 37
            y: 4
            width: 42
            height: 44
            fillMode: Image.PreserveAspectFit
        }
        Text {
            id: statsText
            x: 40
            y: 49
            width: 28
            height: 14
            color: Style.menuText
            text: qsTr("Sales")
            smooth: true
            font.pixelSize: 12
        }

        MouseArea {
            id: statsMArea
            hoverEnabled: true
            anchors.fill: parent
            onEntered: {
                if(String(statslogo.source).search("Hover") === -1){
                    statslogo.source = "image-assets/ledgerHover.png"
                    statsText.color = Style.accentColor
                }
            }
            onExited: {
                if(highlighted !=5){
                    statslogo.source = "image-assets/ledger.png"
                    statsText.color = Style.menuText
                }
            }
            onClicked: {
                moveHighlight(statslogo,statsText)
                highlighted = 5
                insideDashboard.source = "../stats/stats.qml"
            }
            cursorShape: Qt.PointingHandCursor
        }



    }
    Item {
        id: logout_
        x: 1
        y: 649
        width: 116
        height: 68
        Image {
            id: logoutlogo
            source: "image-assets/logout.png"
            x: 43
            y: 19
            width: 31
            height: 31
            opacity: 1
        }
        MouseArea {
            id: logoutMArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                setQMLSource("../UI/login-signup/login.qml")
            }
        }
    }
    Image {
        id: nighMode
        source: "image-assets/" + Style.icon
        x: 87
        y: 741
        opacity: 1
        state: "light"
        MouseArea {
            id: nightModeMArea
            x: 0
            y: -4
            width: 21
            height: 28
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (parent.state == "light") {
                    Style.state = 1
                    Style.change()
                    parent.state = "night"
                } else {
                    Style.state = 0
                    Style.change()
                    parent.state = "light"
                }
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/
