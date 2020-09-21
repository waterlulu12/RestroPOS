import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import "../qmlComponets"
import "../../"

Item {
    signal setQMLSources(string path)
    Material.accent: Style.accentColor

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

        Component.onCompleted: {
            nameText.text = restaurantModel.mo[0].name
            addressText.text = restaurantModel.mo[0].address
            panNoText.text = restaurantModel.mo[0].panNo
            contactText.text = restaurantModel.mo[0].contactNo
            vatText.text = restaurantModel.mo[0].vat
            serviceText.text = restaurantModel.mo[0].serviceCharge
        }
        Rectangle{
            id: restroDetails
            x: 96
            y: 0
            width: 693
            height: 733
            Text {
            id: info
            x: 60
            y: 43
            height: 31
            smooth: true
            text: qsTr("INFO")
            font.pixelSize: 26
        }
        Image {
            id: infoLine
            x: 73
            y: 88
            width: 541
            height: 3
            fillMode: Image.Stretch
            source: "image-assets/line.png"
        }
        Image {
            id: infoedit
            x: 603
            y: 51
            fillMode: Image.PreserveAspectFit
            source: "image-assets/edit.png"
            MouseArea {
                x: 0
                y: -16
                anchors.fill: parent
                onEntered: parent.source = "image-assets/editHover.png"
                onExited: parent.source = "image-assets/edit.png"
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    restroNameE.text = nameText.text
                    addressFieldE.text = addressText.text
                    contactFieldE.text = contactText.text
                    panNoFieldE.text = panNoText.text
                }
            }
        }
        Text {
            id: nameHook
            x: 63
            y: 112
            smooth: true
            text: qsTr("NAME")
            font.pixelSize: 20
        }
        Text {
            id: nameText
            x: 83
            y: 151
            width: 95
            height: 44
            smooth: true
            text: ""
            font.pixelSize: 20
        }
        Text {
            id: contactHook
            x: 63
            y: 212
            width: 135
            height: 25
            smooth: true
            text: qsTr("CONTACT NO")
            font.pixelSize: 20
        }
        Text {
            id: contactText
            x: 83
            y: 250
            width: 122
            height: 37
            smooth: true
            font.pixelSize: 20
        }
        Text {
            id: addressHook
            x: 63
            y: 312
            width: 99
            height: 25
            smooth: true
            text: qsTr("ADDRESS")
            font.pixelSize: 20
        }
        Text {
            id: addressText
            x: 83
            y: 364
            width: 123
            height: 40
            smooth: true
            font.pixelSize: 20
        }
        Text {
            id: panNoHook
            x: 66
            y: 412
            width: 71
            height: 24
            smooth: true
            text: qsTr("PAN NO")
            font.pixelSize: 20
        }
        Text {
            id: panNoText
            x: 83
            y: 457
            width: 117
            height: 37
            smooth: true
            font.pixelSize: 20
        }
        Text {
            id: preference
            x: 64
            y: 532
            smooth: true
            text: qsTr("PREFERENCE")
            font.pixelSize: 26
        }
        Image {
            id: preferenceLine
            x: 83
            y: 580
            width: 541
            height: 3
            fillMode: Image.Stretch
            source: "image-assets/line.png"
        }
        Image {
            id: prefEdit
            x: 603
            y: 536
            fillMode: Image.PreserveAspectFit
            source: "image-assets/edit.png"
            MouseArea {
                x: 0
                y: -16
                anchors.fill: parent
                onEntered: parent.source = "image-assets/editHover.png"
                onExited: parent.source = "image-assets/edit.png"
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: {
                    vatFieldE.text = vatText.text
                    serviceChargeFieldE.text = serviceText.text
                }
            }
        }
        Text {
            id: vatHook
            x: 68
            y: 611
            width: 53
            height: 24
            smooth: true
            text: qsTr("VAT")
            font.pixelSize: 20
        }
        Text {
            id: vatText
            x: 87
            y: 651
            width: 131
            height: 35
            smooth: true
            font.pixelSize: 20
        }
        Text {
            id: serviceHook
            x: 272
            y: 611
            width: 144
            height: 24
            smooth: true
            text: qsTr("SERVICE CHARGE")
            font.pixelSize: 20
        }
        Text {
            id: serviceText
            x: 289
            y: 651
            width: 131
            height: 35
            smooth: true
            font.pixelSize: 20
        }
      }
        Rectangle {
            id: infoEdit
            x: 879
            y: 0
            width: 371
            height: 515
            color: Style.secondaryColor
            Text {
                id: infoTitleE
                x: 27
                y: 39
                color: "#ffffff"
                text: "INFO"
                font.pixelSize: 24
            }
            Image {
                id: itemLine
                x: 27
                y: 85
                source: "image-assets/line.png"
            }
            TextField {
                id: restroNameE
                x: 48
                y: 107
                width: 276
                height: 54
                font.pointSize: 14
                placeholderText: "Restaurant Name"
                color: "#ffffff"
                placeholderTextColor: "#707987"
            }
            TextField {
                id: addressFieldE
                x: 48
                y: 277
                width: 276
                height: 54
                color: "#ffffff"
                text: ""
                placeholderTextColor: "#707987"
                placeholderText: "Address"
                font.pointSize: 14
            }

            TextField {
                id: contactFieldE
                x: 48
                y: 188
                width: 276
                height: 54
                color: "#ffffff"
                text: ""
                placeholderTextColor: "#707987"
                font.pointSize: 14
                placeholderText: "Contact No"
            }
            TextField {
                id: panNoFieldE
                x: 48
                y: 368
                width: 276
                height: 54
                text: ""
                color: "#ffffff"
                placeholderTextColor: "#707987"
                font.pointSize: 14
                placeholderText: "Pan No"
            }
            Image {
                id: saveInfoButton
                x: 280
                y: 449
                source: "../../resources/submit.png"
                smooth: true
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "../../resources/submitHover.png"
                    }
                    onExited: {
                        parent.source = "../../resources/submit.png"
                    }
                    onClicked: {
                        var data = restroNameE.text + "," + contactFieldE.text + ","
                                + addressFieldE.text + "," + panNoFieldE.text
                        sql.updateRestro(restaurantModel.mo[0].id,
                                         "name,contactNo,address,panNO", data)
                        setQMLSources("../profile/profile.qml")
                    }
                }
            }
        }

        Rectangle {
            id: preferenceEdit
            x: 879
            y: 514
            width: 371
            height: 219
            color: Style.secondaryColor

            Text {
                id: preferenceTitleEdit
                x: 27
                y: 24
                color: "#ffffff"
                text: "PREFERENCE"
                font.pixelSize: 24
            }

            Image {
                id: categoryLine
                x: 27
                y: 70
                source: "image-assets/line.png"
            }

            TextField {
                id: vatFieldE
                x: 29
                y: 87
                width: 144
                height: 54
                color: "#ffffff"
                text: ""
                font.pointSize: 14
                placeholderText: "VAT"
                placeholderTextColor: "#707987"
            }
            TextField {
                id: serviceChargeFieldE
                x: 206
                y: 87
                width: 144
                height: 54
                color: "#ffffff"
                text: ""
                placeholderTextColor: "#707987"
                placeholderText: "Service Charge"
                font.pointSize: 14
            }

            Image {
                id: prefSaveButton
                x: 280
                y: 160
                source: "../../resources/submit.png"
                smooth: true
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "../../resources/submitHover.png"
                    }
                    onExited: {
                        parent.source = "../../resources/submit.png"
                    }
                    onClicked: {
                        var data = serviceChargeFieldE.text + "," + vatFieldE.text
                        sql.updateRestro(restaurantModel.mo[0].id,"serviceCharge,vat", data)
                        setQMLSources("../profile/profile.qml")
                    }
                }
            }
        }
    }
}
