import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Window {
    id: rootWindow
    visible: true
    width: 1366
    height: 768
    Material.accent: "#ff704b"
    property int previousX
    property int previousY
    flags: Qt.Window | Qt.FramelessWindowHint
    Rectangle{
        width: 1366
        height: 768
        x:0
        y:0
        color: Style.mainColor
        Connections {
            target: qmlLoader.item
            onSetQMLSource: {qmlLoader.source = path}
        }
        Rectangle {
            id: topBar
            width: 1366
            height: 35
            color: Style.mainColor
            MouseArea {
                id: drag_mArea
                anchors.fill: parent
                onPressed: {
                    previousX = mouseX
                    previousY = mouseY
                }
                onMouseXChanged: {
                    var dx = mouseX - previousX
                    rootWindow.setX(rootWindow.x + 0.4*dx)
                }
                onMouseYChanged: {
                    var dy = mouseY - previousY
                    rootWindow.setY(rootWindow.y + 0.4*dy)
                }
            }

            Image {
                id: minimize
                source: "../../resources/minimize.png"
                x: 1296
                y: 0
                opacity: 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled : true
                    onEntered: {parent.source = "../../resources/minimizehover.png"}
                    onExited: {parent.source = "../../resources/minimize.png"}
                    onClicked: {
                        showMinimized()
                    }
                }
            }
            Image {
                id: cross
                source: "../../resources/cross.png"
                x: 1331
                y: 0
                opacity: 1

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled : true
                    onEntered: {parent.source = "../../resources/crosshover.png"}
                    onExited: {parent.source = "../../resources/cross.png"}
                    onClicked: {rootWindow.close()}
                }

            }

        }

        Loader {
            id: qmlLoader
            source: "UI/login-signup/login.qml"
        }
    }

}
