import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import "../qmlComponets"
import "../../"

Item {
    width: 1250
    height: 733
    Material.accent: Style.accentColor
    signal setQMLSources(string path)
    property var total: 0
    property var dAmt: 0
    property var service: 0
    property var vamt: 0
    property var gtotal: 0
    property int currItem: 0
    property var quant: []
    property string restroName: ""
    property string restroAddress: ""
    property string restroContact: ""
    property string panNo: ""
    property string name: ""
    property string oId: ""

    function clearFlags() {
        quant = []
    }
    JSONListModel {
        id: billdetails
        json: ""
    }
    JSONListModel{
        id: restroDetails
        json: ""
    }
    function setFlags(curr) {
        billdetails.json = sql.getBillDetails(curr)
        billList.model = menuLoadID.model
        total = billdetails.mo[0].total
        dAmt = billdetails.mo[0].discount
        panNo = billdetails.mo[0].panNo
        gtotal = billdetails.mo[0].gtotal
        gtotaltext.text = gtotal
        service = billdetails.mo[0].service
        vamt = billdetails.mo[0].vat
        serviceCharge.text = service
        vatText.text = vamt
        serviceChargeSwitch.checked = true
        vatChargeSwitch.checked = true
        printBillSample.model = menuLoadID.model
    }
    function showBill(){
        customerName.text = billTitle.text
        orderToken.text = billOId.text
        printBillTotal.text = totaltext.text
        printBillDis.text = discounttext.text
        printBillVAT.text = vatText.text
        printBillService.text = serviceCharge.text
        printBillGTotal.text = gtotaltext.text
        restroDetails.json = sql.getRestaurant()
        restroName = restroDetails.mo[0].name
        restroAddress = restroDetails.mo[0].address
        restroContact = restroDetails.mo[0].contactNo
        printBillTitle.text = restroName
        printBillPan.text = panNo
        printBillAddress.text = restroAddress
        printBillContact.text = restroContact
    }
    Rectangle {
        x: 0
        y: 0
        width: 1268
        height: 752
        color: Style.backgroundColor
        radius: 25
        smooth: true
        Rectangle {
            id: billingContainer
            x: 39
            y: 0
            width: 788
            height: 733
            Rectangle {
                id: selectedOrder
                x: 40
                y: 37
                width: 720
                height: 268
                color: Style.basicColor2
                border.width: 3
                border.color: Style.borders
                Text {
                    x: 30
                    y: 28
                    color: Style.basicColor
                    id: selectedOTexthook
                    text: "Customer Name: "
                    font.family: "BillCorporate"
                    font.pointSize: 18
                    smooth: true
                }
                Text {
                    x: 220
                    y: 31
                    width: 240
                    color: Style.basicColor
                    id: selectedOText
                    elide: Text.ElideRight
                    text: ""
                    font.family: "BillCorporate"
                    font.pointSize: 16
                    smooth: true
                }
                Text {
                    id: selectedOIdhook
                    x: 520
                    y: 28
                    color: Style.basicColor
                    text: "Order ID: "
                    font.family: "BillCorporate"
                    font.pointSize: 14
                    smooth: true
                }
                Text {
                    id: selectedOId
                    x: 610
                    y: 28
                    color: Style.basicColor
                    text: ""
                    font.family: "BillCorporate"
                    font.pointSize: 14
                    smooth: true
                }
                Text {
                    id: tPricehook
                    x: 520
                    y: 88
                    color: Style.basicColor
                    text: "Total: "
                    font.family: "BillCorporate"
                    font.pointSize: 16
                    smooth: true
                }
                Text {
                    id: tPrice
                    x: 608
                    y: 88
                    color: Style.basicColor
                    text: total
                    font.family: "BillCorporate"
                    font.pointSize: 16
                    smooth: true
                }

                ScrollView {
                    x: 40
                    y: 85
                    id: itemView
                    width: 500
                    height: 160
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AlwaysOff
                    }
                    ListView {
                        id: itemModel
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true
                        JSONListModel {
                            id: menuLoadID
                            json: ""
                        }
                        model: menuLoadID.model
                        delegate: ItemDelegate {
                            Material.accent: "#000000"
                            id: menuItemDelegate
                            Text {
                                x: 0
                                width: 230
                                elide: Text.ElideRight
                                color: Style.basicColor
                                text: model.name
                                font.pointSize: 14
                                smooth: true
                                font.family: "Ubuntu"
                            }
                            Text {
                                x: 250
                                color: Style.basicColor
                                font.pointSize: 14
                                smooth: true
                                font.family: "Ubuntu"
                                Component.onCompleted: {
                                    text = quant[index]
                                }
                            }
                            Text {
                                x: 290
                                color: Style.basicColor
                                text: "Rs. " + model.price
                                font.pointSize: 14
                                smooth: true
                                font.family: "Ubuntu"
                            }
                        }
                    }
                }
            }

            ScrollView {
                id: salesView
                x: 74
                y: 330
                width: 644
                height: 385
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOff
                }

                ListView {
                    id: salesModel
                    x: 115
                    y: 311
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    width: parent.width
                    height: parent.height
                    JSONListModel {
                        id: salesModelList
                        json: sql.getSales("0")
                    }
                    model: salesModelList.model
                    delegate: ItemDelegate {
                        width: 644
                        height: 80
                        id: itemDelegate
                        Text {
                            Material.theme: Material.Dark
                            x: 50
                            y: 20
                            width: 150
                            elide: Text.ElideRight
                            id: textBoxCategory
                            text: model.customer
                            font.pointSize: 16
                            color: Style.basicColor
                            smooth: true
                        }
                        Text {
                            x: 260
                            y: 20
                            width: 70
                            elide: Text.ElideRight
                            id: orderId
                            text: "OT10" + model.id
                            color: Style.basicColor
                            smooth: true
                        }
                        Image {
                            id: deleteSalesButton
                            x: 410
                            y: 30
                            width: 22
                            height: 3
                            source: "image-assets/remove.png"
                            MouseArea {
                                x: 0
                                y: -30
                                width: 35
                                height: 35
                                id: categoryDMArea
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: parent.source = "image-assets/removeHover.png"
                                onExited: parent.source = "image-assets/remove.png"
                                onClicked: {
                                    sql.deleteSales(model.id)
                                    setQMLSources("../billing/billing.qml")
                                }
                            }
                        }
                        MouseArea {
                            x: 0
                            y: 0
                            width: 410
                            height: 80
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (currItem > model.id
                                        || currItem < model.id) {
                                    menuLoadID.json = sql.getIDetails(
                                                model.menuItems)
                                    selectedOText.text = model.customer
                                    selectedOId.text = "OT10" + model.id
                                    billTitle.text = model.customer
                                    billOId.text = "OT10" + model.id
                                    clearFlags()
                                    quant = String(model.quantity).split(",")
                                    currItem = model.id
                                    setFlags(currItem)
                                }
                            }
                        }
                    }
                }
            }
        }

        Popup {
            id: billPopUp
            width: 600
            height: 700
            x: 280
            y: 10
            padding: 0
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
            onClosed: {
                setQMLSources("../billing/billing.qml")
            }
            Image {
                x: 20
                y: 20
                width: 125
                height: 59
                source: "../../resources/logo.png"
            }

            Image {
                x: 520
                y: 20
                smooth: true
                source: "../../resources/print.png"
                MouseArea{
                    hoverEnabled: true
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onEntered: parent.source = "../../resources/printhover.png"
                    onExited: parent.source = "../../resources/print.png"
                    onClicked: {
                        var billFileName = orderToken.text+"_"+customerName.text+".xls"
                        sql.printPurchaseBill(billFileName)
                    }
                }
            }

            Text {
                x: 20
                y: 95
                id: billtoText
                text: "BILL TO"
                font.pointSize: 14
            }
            Text {
                x: 20
                y: 130
                id: customerName
                font.pointSize: 13
            }
            Text {
                x: 20
                y: 160
                id: orderToken
                font.pointSize: 13
            }
            Text {
                x: 460
                y: 95
                id: billfromText
                text: "BILL FROM"
                font.pointSize: 14
            }
            Text {
                x: 460
                y: 130
                id: printBillTitle
                font.pointSize: 13
            }
            Text {
                x: 460
                y: 160
                id: printBillPan
                font.pointSize: 13
            }
            Text {
                x: 460
                y: 190
                id: printBillAddress
                font.pointSize: 13
            }
            Text {
                x: 460
                y: 220
                id: printBillContact
                font.pointSize: 13
            }

            Rectangle {
                width: 600
                height: 40
                y: 250
                color: "#000000"
                Text {
                    x: 25
                    y: 10
                    color: "#ffffff"
                    text: qsTr("Name")
                    font.pointSize: 12
                }
                Text {
                    x: 320
                    y: 10
                    color: "#ffffff"
                    text: qsTr("Qt.")
                    font.pointSize: 12
                }
                Text {
                    x: 380
                    y: 10
                    color: "#ffffff"
                    text: qsTr("Price")
                    font.pointSize: 12
                }
                Text {
                    x: 460
                    y: 10
                    color: "#ffffff"
                    text: qsTr("Total Price")
                    font.pointSize: 12
                }
            }

            ScrollView {
                x: 0
                y: 295
                width: 600
                height: 240
                ListView {
                    id: printBillSample
                    x:0
                    y:0
                    clip: true
                    model: ""
                    boundsBehavior: Flickable.StopAtBounds
                    delegate: ItemDelegate {
                        Text {
                            x: 25
                            width: 290
                            elide: Text.ElideRight
                            text: model.name
                            font.pointSize: 14
                            smooth: true
                            font.family: "Ubuntu"
                        }
                        Text {
                            x: 330
                            font.pointSize: 14
                            smooth: true
                            font.family: "Ubuntu"
                            Component.onCompleted: {
                                text = quant[index]
                            }
                        }
                        Text {
                            x: 382
                            text: model.price
                            font.pointSize: 14
                            smooth: true
                            font.family: "Ubuntu"
                        }
                        Text {
                            x: 460
                            width: 76
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                            font.pointSize: 14
                            smooth: true
                            font.family: "Ubuntu"
                            Component.onCompleted: {
                                text = parseFloat(model.price) * parseInt(
                                            quant[index])
                            }
                        }
                    }
                }
            }

            Text {
                x: 428
                y: 540
                smooth: true
                font.pointSize: 14
                text : "Total:"
            }

            Text {
                id: printBillTotal
                x: 495
                y: 540
                smooth: true
                font.pointSize: 14
            }

            Text {
                x: 398
                y: 570
                smooth: true
                font.pointSize: 14
                text : "Discount:"
            }

            Text {
                id: printBillDis
                x: 495
                y: 570
                smooth: true
                font.pointSize: 14
            }

            Text {
                x: 438
                y: 600
                smooth: true
                font.pointSize: 14
                text : "VAT:"
            }

            Text {
                id: printBillVAT
                x: 495
                y: 600
                smooth: true
                font.pointSize: 14
            }

            Text {
                x: 410
                y: 630
                smooth: true
                font.pointSize: 14
                text : "Service:"
            }

            Text {
                id: printBillService
                x: 495
                y: 630
                smooth: true
                font.pointSize: 14
            }

            Text {
                x: 370
                y: 660
                smooth: true
                font.pointSize: 14
                text : "Grand Total:"
            }

            Text {
                id: printBillGTotal
                x: 495
                y: 660
                smooth: true
                font.pointSize: 14
            }
        }

        Rectangle {
            x: 879
            y: 0
            width: 371
            height: 733
            color: Style.secondaryColor

            Text {
                id: billingTitleBox
                x: 241
                y: 19
                width: 114
                height: 33
                color: "#ffffff"
                text: qsTr("BILLING")
                font.pixelSize: 30
            }

            Image {
                id: billLine
                x: 226
                y: 63
                width: 129
                source: "image-assets/line.png"
            }

            Text {
                id: panNoText
                x: 216
                y: 73
                width: 73
                height: 24
                color: "#ffffff"
                text: "PAN NO:" + panNo
                font.pixelSize: 14
            }

            Text {
                x: 25
                y: 95
                width: 170
                elide: Text.ElideRight
                id: billTitle
                font.family: "BillCorporate"
                font.pointSize: 18
                color: "#ffffff"
                smooth: true
            }
            Text {
                x: 201
                y: 98
                width: 160
                height: 29
                elide: Text.ElideRight
                id: billOId
                font.pointSize: 18
                color: "#ffffff"
                smooth: true
            }

            Text {
                id: billItemName
                x: 25
                y: 150
                color: "#ffffff"
                text: qsTr("Name")
                font.pointSize: 12
            }
            Text {
                id: billQT
                x: 138
                y: 150
                color: "#ffffff"
                text: qsTr("Qt.")
                font.pointSize: 12
            }
            Text {
                id: billTNPrice
                x: 188
                y: 150
                color: "#ffffff"
                text: qsTr("Price")
                font.pointSize: 12
            }
            Text {
                id: billItotal
                x: 260
                y: 150
                color: "#ffffff"
                text: qsTr("Total Price")
                font.pointSize: 12
            }
            ScrollView {
                x: 25
                y: 190
                width: 337
                height: 254
                ListView {
                    id: billList
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    model: ""
                    delegate: ItemDelegate {
                        x: 0
                        Material.accent: "#000000"
                        id: billListView
                        Text {
                            x: 0
                            width: 80
                            elide: Text.ElideRight
                            color: "#ffffff"
                            text: model.name
                            font.pointSize: 14
                            smooth: true
                            font.family: "Ubuntu"
                        }
                        Text {
                            x: 118
                            color: "#ffffff"
                            font.pointSize: 14
                            smooth: true
                            font.family: "Ubuntu"
                            Component.onCompleted: {
                                text = quant[index]
                            }
                        }
                        Text {
                            x: 164
                            color: "#ffffff"
                            text: model.price
                            font.pointSize: 14
                            smooth: true
                            font.family: "Ubuntu"
                        }
                        Text {
                            x: 240
                            width: 76
                            color: "#ffffff"
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignRight
                            font.pointSize: 14
                            smooth: true
                            font.family: "Ubuntu"
                            Component.onCompleted: {
                                text = parseFloat(model.price) * parseInt(
                                            quant[index])
                            }
                        }
                    }
                }
            }

            Switch {
                id: vatChargeSwitch
                x: 115
                y: 437
                display: AbstractButton.IconOnly
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (parent.checked == true) {
                            parent.checked = false
                            gtotaltext.text = (parseFloat(
                                                   gtotaltext.text) - parseFloat(
                                                   vamt)).toFixed(1)
                            vatText.text = 0
                        } else {
                            parent.checked = true
                            gtotaltext.text = (parseFloat(
                                                   gtotaltext.text) + parseFloat(
                                                   vamt)).toFixed(1)
                            vatText.text = vamt
                        }
                    }
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Switch {
                id: serviceChargeSwitch
                x: 200
                y: 437
                display: AbstractButton.IconOnly
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (parent.checked == true) {
                            gtotaltext.text = (parseFloat(
                                                   gtotaltext.text) - parseFloat(
                                                   service)).toFixed(1)
                            serviceCharge.text = 0
                            parent.checked = false
                        } else {
                            gtotaltext.text = (parseFloat(
                                                   gtotaltext.text) + parseFloat(
                                                   service)).toFixed(1)
                            serviceCharge.text = service
                            parent.checked = true
                        }
                    }
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Text {
                x: 173
                y: 450
                id: vatSwitchText
                color: "#ffffff"
                text: "VAT"
                font.pointSize: 12
            }

            Text {
                x: 255
                y: 450
                id: serviceCheckText
                color: "#ffffff"
                text: "Service Charge"
                font.pointSize: 12
            }

            Text {
                x: 113
                y: 493
                id: totalhook
                smooth: true
                color: "#ffffff"
                text: "Total:"
                font.pointSize: 14
            }

            Text {
                x: 192
                y: 493
                id: totaltext
                smooth: true
                color: "#ffffff"
                text: total
                font.pointSize: 14
            }
            Text {
                x: 81
                y: 526
                id: discounthook
                smooth: true
                color: "#ffffff"
                text: "Discount:"
                font.pointSize: 14
            }
            Text {
                x: 192
                y: 526
                id: discounttext
                smooth: true
                color: "#ffffff"
                text: dAmt
                font.pointSize: 14
            }

            Text {
                x: 119
                y: 559
                id: vatTextHook
                smooth: true
                color: "#ffffff"
                text: "VAT: "
                font.pointSize: 14
            }

            Text {
                x: 192
                y: 559
                id: vatText
                smooth: true
                color: "#ffffff"
                text: "0"
                font.pointSize: 14
            }
            Text {
                x: 93
                y: 592
                id: serviceChargehook
                smooth: true
                color: "#ffffff"
                text: "Service:"
                font.pointSize: 14
            }
            Text {
                x: 192
                y: 592
                id: serviceCharge
                smooth: true
                color: "#ffffff"
                text: "0"
                font.pointSize: 14
            }
            Text {
                x: 54
                y: 625
                id: gtotalhook
                smooth: true
                color: "#ffffff"
                text: "Grand Total:"
                font.pointSize: 14
            }

            Text {
                x: 192
                y: 625
                width: 12
                height: 23
                id: gtotaltext
                smooth: true
                color: "#ffffff"
                text: "0.0"
                font.pointSize: 14
            }
            Image {
                id: billSButton
                x: 290
                y: 664
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
                        var data = gtotaltext.text + "," + discounttext.text + ", "
                                + serviceCharge.text + "," + vatText.text + ", 1"
                        billPopUp.open()
                        sql.submitBillButton(
                                    currItem,
                                    "totalPrice, discount, serviceCharge, vat, oComplete",
                                    data)
                        sql.createBill(billOId.text.substr(4))
                        showBill()
                    }
                }
            }
        }
    }
}
