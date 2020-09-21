import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import "../qmlComponets"
import "../../"
Item {
    signal setQMLSources(string path)
    Material.accent: Style.accentColor
    property string sdate: JSON.parse(sql.getSalesBound())[0].date
    property string edate: JSON.parse(sql.getSalesBound())[1].date
    property string sy: "2020"
    property string sm: ""
    property string sd: ""
    property string ey: "2020"
    property string em: ""
    property string ed: ""

    property int grossrev: 0
    property int totalItemsS: 0
    property int discounT: 0
    property int totalO: 0
    property int vatT: 0
    property int serviceT: 0

    function getSelect(bound){
        var temp=[]
        for(var i=0;i<=bound;i++){
            temp.push(i)
        }
        return temp
    }
    function clearFlags(){
        grossrev = ""
        totalItemsS = ""
        discounT = ""
        totalO = ""
        vatT = ""
        serviceT = ""
    }
    function calcInfo() {
        if ( salesModelList.json === "" )
            return;
        var temp;
        var objectArray = JSON.parse(salesModelList.json)
        totalO = objectArray.length

        for ( var key in objectArray ) {
            grossrev += parseInt(objectArray[key].totalPrice)
            temp = objectArray[key].menuItems
            totalItemsS += (((temp.match(/,/g) || []).length) + 1)
            vatT += parseInt(objectArray[key].vat)
            discounT += parseInt(objectArray[key].discount)
            serviceT += parseInt(objectArray[key].serviceCharge)
        }
    }

    Rectangle{
        x: 0
        y: 0
        width: 1268
        height: 752
        color: Style.backgroundColor
        radius: 25
        smooth: true
        Rectangle{
            id: salesContainer
            x: 39
            y: 0
            width: 711
            height: 733
            Text{
            x: 20
            y: 48
            smooth: true
            color: "#707987"
            text: "* Data Available From " + sdate + " To " + edate
            font.pointSize: 12

        }
        ComboBox{
            id: syearSelect
            x: 19
            y: 75
            width: 88
            height: 41
            model: ["2020"]
        }
        ComboBox{
            id: smonthSelect
            x: 113
            y: 75
            width: 69
            height: 41
            onCurrentTextChanged: {
                sm = currentText
            }
            model: getSelect(12)
        }
        ComboBox{
            id: sdaySelect
            x: 180
            y: 75
            width: 69
            height: 41
            onCurrentTextChanged: {
                sd = currentText
            }
            model: getSelect(30)
        }
        ComboBox{
            id: eyearSelect
            x: 276
            y: 75
            width: 88
            height: 41
            model: ["2020"]
        }
        ComboBox{
            id: emonthSelect
            x: 370
            y: 75
            width: 69
            height: 41
            onCurrentTextChanged: {
                em = currentText
            }
            model: getSelect(12)
        }
        ComboBox{
            id: edaySelect
            x: 437
            y: 75
            width: 69
            height: 41
            onCurrentTextChanged: {
                ed = currentText
            }
            model: getSelect(30)
        }
        Image {
            id: applyDate
            x: 532
            y: 80
            source: "../../resources/tick.png"
            smooth: true
            MouseArea{
                id: billSButtonMArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: { parent.source = "../../resources/tickHover.png"}
                onExited: { parent.source = "../../resources/tick.png"}
                onClicked: {
                    salesModelList.json=sql.getSalesByDate(sy+"-"+sm+"-"+sd,ey+"-"+em+"-"+ed)
                    clearFlags()
                    calcInfo()
                }
                onPressed: { parent.state="Pressed" }
                onReleased: {
                    if (containsMouse)
                        parent.state="Hovering";
                    else
                        parent.state="";
                }
            }
        }

        Text {
            x:20
            y:139
            elide: Text.ElideRight
            width:50
            height: 24
            id: snhook
            text: "SN"
            font.pointSize: 12
            color: Style.basicColor
            smooth: true
        }
        Text {
            x:76
            y:139
            elide: Text.ElideRight
            width:71
            height: 24
            id: namehook
            text: "Order ID"
            font.pointSize: 12
            color: Style.basicColor
            smooth: true
        }
        Text {
            x:166
            y:139
            elide: Text.ElideRight
            width:112
            height: 24
            id: orderhook
            text: "Name"
            font.pointSize: 12
            color: Style.basicColor
            smooth: true
        }
        Text {
            x:301
            y:139
            elide: Text.ElideRight
            width:74
            height: 24
            id: salehook
            text: "Sale Price"
            font.pointSize: 12
            color: Style.basicColor
            smooth: true
        }
        Text {
            x:411
            y:139
            elide: Text.ElideRight
            width:65
            height: 24
            id: discounthook
            text: "Discount"
            font.pointSize: 12
            color: Style.basicColor

            smooth: true
        }
        Text {
            x:520
            y:139
            elide: Text.ElideRight
            width:56
            height: 24
            id: servicehook
            text: "Service"
            font.pointSize: 12
            color: Style.basicColor
            smooth: true
        }

        Text {
            x:618
            y:139
            elide: Text.ElideRight
            width:37
            height: 24
            id: vathook
            text: "VAT"
            font.pointSize: 12
            color: Style.basicColor
            smooth: true
        }


        ScrollView {
            id: salesView
            x: 20
            y: 169
            width: 669
            height: 529
            ScrollBar.vertical: ScrollBar{
                policy: ScrollBar.AlwaysOff
            }

            ListView {
                id: salesModel
                x: 13
                y: 167
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                width: parent.width
                height: parent.height

                JSONListModel {
                    id: salesModelList
                    json: ""
                }

                model: salesModelList.model
                delegate: ItemDelegate {
                    width: 660
                    height: 80
                    state: "close"
                    id: itemDelegate
                    Text {
                        Material.theme: Material.Dark
                        x:10
                        y:16
                        elide: Text.ElideRight
                        clip:true
                        width:50
                        height: 24
                        id: saleSN
                        text: index + 1
                        font.pointSize: 12
                        color: Style.basicColor
                        smooth: true
                    }
                    Text {
                        Material.theme: Material.Dark
                        x:66
                        y:16
                        elide: Text.ElideRight
                        clip:true
                        width:71
                        height: 24
                        id: saleOrderId
                        text: "OT10"+model.id
                        font.pointSize: 12
                        color: Style.basicColor
                        smooth: true
                    }
                    Text {
                        Material.theme: Material.Dark
                        x:147
                        y:16
                        clip:true
                        width:95
                        height: 24
                        elide: Text.ElideRight
                        id: saleName
                        text: model.customer
                        font.pointSize: 12
                        color: Style.basicColor
                        smooth: true
                    }
                    Text {
                        Material.theme: Material.Dark
                        x:236
                        y:16
                        width:110
                        height: 24
                        id: saleCost
                        text: model.totalPrice
                        horizontalAlignment: Text.AlignRight
                        font.pointSize: 12
                        color: Style.basicColor
                        smooth: true
                    }
                    Text {
                        Material.theme: Material.Dark
                        x:330
                        y:16
                        width: 118
                        height: 24
                        horizontalAlignment: Text.AlignRight
                        id: saleDis
                        elide: Text.ElideRight
                        text: model.discount
                        font.pointSize: 12
                        color: Style.basicColor
                        smooth: true
                    }
                    Text {
                        Material.theme: Material.Dark
                        x:494
                        y:16
                        width:58
                        height: 24
                        id: saleService
                        horizontalAlignment: Text.AlignRight
                        text: model.serviceCharge
                        font.pointSize: 12
                        color: Style.basicColor
                        smooth: true
                    }
                    Text {
                        Material.theme: Material.Dark
                        x:580
                        y:16
                        width:56
                        height: 24
                        id: saleVat
                        text: model.vat
                        horizontalAlignment: Text.AlignRight
                        font.pointSize: 12
                        color: Style.basicColor
                        smooth: true
                    }
                }
            }
        }
     }
        Item {

            id: infoBox
            x: 743
            y: 75
            width: 463
            height: 623

            Rectangle {
                id: grossRevenue
                x: 19
                y: 19
                width: 207
                radius: 15
                height: 161
                color: "#011627"
                smooth: true

                Text {
                    id: grossRevenueText
                    x: 19
                    y: 20
                    width: 135
                    height: 16
                    color: "#ffffff"
                    smooth: true
                    font.family: "Varela Round"
                    text: qsTr("Gross Revenue (Rs): ")
                    font.pixelSize: 14
                }

                Text {
                    id: grossRevenueValue
                    x: 45
                    y: 78
                    width: 109
                    height: 46
                    color: "#ffffff"
                    smooth: true
                    font.family: "QuickSand"
                    text: grossrev
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 36
                }


            }

            Rectangle {
                id: totalItems
                x: 258
                y: 19
                width: 187
                radius: 15
                height: 238
                color: Style.color1
                smooth: true

                Text {
                  id: totalItemText
                  x: 42
                  y: 20
                  color: "#ffffff"
                  smooth: true
                  text: qsTr("Total Item Sold:")
                  font.pixelSize: 14
                 }

                Text {
                  id: totalItemValue
                  x: 64
                  y: 130
                  width: 101
                  height: 52
                  color: "#ffffff"
                  text: "0"
                  smooth: true
                  horizontalAlignment: Text.AlignRight
                  font.family: "QuickSand"
                  font.pixelSize: 36
                }
            }

            Rectangle {
                id: totaldiscounts
                x: 19
                y: 197
                width: 207
                radius: 15
                height: 253
                color: Style.color2
                smooth: true

                Text {
                    id: totalDiscountText
                    x: 30
                    y: 25
                    width: 135
                    height: 16
                    color: "#ffffff"
                    smooth: true
                    font.family: "Varela Round"
                    text: qsTr("Total Discounts (Rs):")
                    font.pixelSize: 14
                }

                Text {
                    id: totalDiscountValue
                    x: 8
                    y: 147
                    width: 142
                    height: 46
                    color: "#ffffff"
                    smooth: true
                    font.family: "QuickSand"
                    text: discounT
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 36
                }
            }

            Rectangle {
                id: totalOrders
                x: 258
                y: 270
                width: 187
                height: 180
                radius: 15
                color: Style.color3
                smooth: true

                Text {
                    id: totalOrderText
                    x: 72
                    y: 16
                    color: "#ffffff"
                    smooth: true
                    text: qsTr("Total Orders")
                    font.pixelSize: 14
                }

                Text {
                    id: totalOrderValue
                    x: 58
                    y: 73
                    width: 105
                    height: 54
                    color: "#ffffff"
                    text: totalO
                    smooth: true
                    horizontalAlignment: Text.AlignRight
                    font.family: "QuickSand"
                    font.pixelSize: 36
                }

            }

            Rectangle {
                id: totalServiceVat
                x: 19
                y: 466
                width: 426
                radius: 15
                height: 137
                color: Style.color5
                smooth: true

                Text {
                    id: serviceText
                    x: 39
                    y: 13
                    width: 138
                    height: 16
                    color: "#ffffff"
                    smooth: true
                    font.family: "Varela Round"
                    text: qsTr("Service Charge Total:")
                    font.pixelSize: 14
                }

                Text {
                    id: serviceValue
                    x: 43
                    y: 56
                    width: 138
                    height: 46
                    color: "#ffffff"
                    smooth: true
                    font.family: "QuickSand"
                    text: serviceT
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 38
                }

                Text {
                    id: vatText
                    x: 299
                    y: 12
                    width: 97
                    height: 16
                    color: "#ffffff"
                    smooth: true
                    font.family: "Varela Round"
                    text: qsTr("VAT Total (Rs)")
                    font.pixelSize: 14
                }

                Text {
                    id: vatValue
                    x: 255
                    y: 57
                    width: 149
                    height: 46
                    color: "#ffffff"
                    smooth: true
                    font.family: "QuickSand"
                    text: vatT
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 38
                }
            }


        }



    }

}
