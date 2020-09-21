import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import "UI/qmlComponets"

Window {
    id: rootWindow
    visible: true
    width: 1366
    height: 768
    property int previousX
    property int previousY
    property var orderList: ListModel {}
    property var netTotal: 0
    property var dAmt: 0
    property var gtotalN: 0
    property var newOrder: ""
    property int i: 0
    property string currCat: "Thakali Snacks"
    flags: Qt.Window | Qt.FramelessWindowHint

    function setOrder(name, id, price, discount, mode) {
        var i = 0
        var flag = 0
        var pos = 0
        if (orderList.count === 0) {
            orderList.clear()
            flag = 0
        } else {
            for (i = 0; i < orderList.count; i++) {
                if (orderList.get(i).id === id) {
                    flag = 1
                    pos = i
                    break
                } else {
                    flag = 0
                }
            }
        }
        if (mode === 0) {
            if (orderList.get(pos).count === 1) {
                orderList.remove(pos)
                return 1
            }
            var tempcount1 = orderList.get(pos).count - 1
            var temptotal1 = orderList.get(pos).totalprice - orderList.get(
                        pos).price
            orderList.set(pos, {
                              "name": name,
                              "id": id,
                              "count": tempcount1,
                              "price": price,
                              "discount": discount,
                              "totalprice": temptotal1
                          })
            return 1
        }
        if (flag === 0) {
            var temp = {
                "name": name,
                "id": id,
                "count": 1,
                "price": price,
                "discount": discount,
                "totalprice": price
            }
            orderList.append(temp)
        } else {
            var tempcount = orderList.get(pos).count + 1
            var temptotal = tempcount * orderList.get(pos).price
            orderList.set(pos, {
                              "name": name,
                              "id": id,
                              "count": tempcount,
                              "price": price,
                              "discount": discount,
                              "totalprice": temptotal
                          })
        }
    }

    function sortItems() {
        for (var i = 1; i < orderList.count; ++i) {
            var key = orderList.get(i).id
            var temp = {
                "name": orderList.get(i).name,
                "id": orderList.get(i).id,
                "count": orderList.get(i).count,
                "price": orderList.get(i).price,
                "discount": orderList.get(i).discount,
                "totalprice": orderList.get(i).totalprice
            }
            var j = i - 1
            while (j >= 0 && orderList.get(j).id > key) {
                orderList.move(j + 1, j, 1)
                j = j - 1
            }
            orderList.set(j + 1, temp)
        }
    }
    function clear() {
        orderList.clear()
        netTotal = 0
        dAmt = 0
        gtotalN = 0
    }
    function makeOrder() {
        var query = customerName.text + ",0,0,0,0,0"
        var query2 = "\""
        var query3 = "\""
        for (var i = 0; i < orderList.count; i++) {
            query2 += orderList.get(i).id + ","
            query3 += orderList.get(i).count + ","
        }
        query2 = query2.substring(0, query2.length - 1)
        query3 = query3.substring(0, query3.length - 1)
        query2 += "\""
        query3 += "\""
        var temp = query3 + "," + query2
        var latest = sql.createSales(query, temp)
        newOrder = "OT10" + latest
        clear()
        endPopup.open()
    }

    function calcTotal() {
        if (orderList.count === 0) {
            netTotal = 0.0
            dAmt = 0.0
            gtotalN = 0.0
        } else {
            var total = 0
            var discount = 0
            for (var i = 0; i < orderList.count; i++) {
                total += orderList.get(i).totalprice
                discount += (parseFloat(orderList.get(
                                            i).discount) / 100) * parseFloat(
                            orderList.get(i).totalprice)
            }
            var gtotal = total - discount
            netTotal = total
            dAmt = discount
            gtotalN = gtotal
        }
    }

    Rectangle{
        width: 1366
        height: 768
        color: Style.mainColor

        Pane {
            x: 0
            y: 0
            padding: 0
            Material.elevation: 2
            width: 206
            height: 768
            smooth: true
            Pane {
                x: 0
                y: 0
                width: 206
                height: 107
                padding: 0
                id: sideBartop
                Material.background: Style.mainColor
                Image {
                    id: image
                    x: 42
                    y: 28
                    source: "resources/logo.png"
                }
            }
            Pane {
                x: 0
                y: 107
                id: sideBarbot
                width: 206
                height: 661
                padding: 0
                Material.background: Style.mainColor

                ListView {
                    id: categoryModel
                    y: 24
                    width: 239
                    height: 619
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true

                    JSONListModel {
                        id: categoryModelList
                        json: sql.getCategory()
                    }
                    model: categoryModelList.model
                    delegate: ItemDelegate {
                        highlighted: ListView.isCurrentItem
                        width: 239
                        height: 60
                        state: "close"
                        id: itemDelegate
                        Component.onCompleted: {
                            if (i == 0) {
                                itemList.json = sql.getMenuItem("*", "category",
                                                                model.id)
                                currentTitle.text = model.category
                                i++
                            }
                        }
                        Text {
                            x: 20
                            y: 15
                            width: 185
                            elide: Text.ElideRight
                            id: textBoxCategory
                            font.pointSize: 13
                            color: Style.basicColor2
                            smooth: true
                            text: model.category
                        }
                        MouseArea {
                            id: categoryMArea
                            x: 0
                            y: 0
                            width: 410
                            height: 80
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (parent.state == "close") {
                                    itemList.json = sql.getMenuItem("*",
                                                                    "category",
                                                                    model.id)
                                    currentTitle.text = model.category
                                    currCat = model.category
                                } else {
                                    itemList.json = ""
                                    currentTitle.text = ""
                                }
                                categoryModel.currentIndex = index
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: midView
            x: 206
            y: 35
            width: 775
            height: 754
            radius: 25
            smooth: true

            JSONListModel {
                id: itemList
                json: ""
            }
            Text {
                id: currentTitle
                y: 19
                horizontalAlignment: Text.AlignHCenter
                width: 723
                height: 39
                font.pixelSize: 32
            }
            GridView {
                id: itemGrid
                x: 30
                y: 97
                width: 712
                height: 620
                cellWidth: 233
                cellHeight: 260
                clip: true
                state: "notHovered"
                boundsBehavior: Flickable.StopAtBounds
                model: itemList.model
                delegate: ItemDelegate {
                    width: 225
                    height: 250
                    Rectangle {
                        color: "#f3f3f7"
                        id: itemDel
                        y: 5
                        width: 225
                        height: 250
                        clip: true
                        radius: 10
                        Image {
                            width: 225
                            height: 170
                            Component.onCompleted: {
                                if (model.itemImage === "") {
                                    source = "resources/temp.jpg"
                                } else {
                                    source = "data:image/jpeg;base64," + model.itemImage
                                }
                            }
                        }
                        Text {
                            x: 10
                            y: 180
                            text: model.name
                            wrapMode: Text.WordWrap
                            width: 205
                            smooth: true
                            clip: true
                        }
                        Text {
                            x: 120
                            y: 220
                            text: "Rs. "
                            smooth: true
                        }
                        Text {
                            x: 160
                            y: 220
                            width: 54
                            text: model.price
                            horizontalAlignment: Text.AlignRight
                            smooth: true
                        }
                        MouseArea {
                            id: itemMArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                setOrder(model.name, model.id,
                                         parseInt(model.price),
                                         parseFloat(model.discount), 1)
                                calcTotal()
                                sortItems()
                            }
                        }

                        Rectangle{
                            x:200
                            y:2
                            width: 20
                            height: 20
                            color: Style.mainColor
                            opacity: 0.8
                            radius: 30
                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    itemNamePopUp.text = model.name
                                    itemDescriptionPopUp.text = model.description
                                    itemPricePopUp.text = "Rs. " + model.price
                                    if (model.itemImage === "") {
                                        itemImagePopUp.source = "resources/temp.jpg"
                                    } else {
                                        itemImagePopUp.source = "data:image/jpeg;base64," + model.itemImage
                                    }
                                    itemPopUp.open()
                                }
                            }
                        }

                        Image{
                            x:200
                            y:2
                            source: "resources/info.png"
                        }
                    }
                }
            }
        }

        Popup {
            id: itemPopUp
            x: 390
            y: 240
            width: 680
            height: 300
            padding: 0
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

                Image{
                    id:itemImagePopUp
                    width: 280
                    height: 215
                    x: 10
                    y: 10
                }
                Text {
                    id: itemNamePopUp
                    width: 380
                    height: 70
                    wrapMode: Text.WordWrap
                    clip: true
                    x: 300
                    y: 10
                    font.pointSize: 23
                    smooth: true
                }

                Text {
                    id: itemCatPopUp
                    width: 280
                    height: 200
                    x: 300
                    y: 85
                    font.pointSize: 16
                    text: currCat
                    smooth: true
                }

                Text {
                    id: itemPricePopUp
                    width: 280
                    height: 200
                    x: 300
                    y: 115
                    font.pointSize: 16
                    smooth: true
                }

                Text {
                    id: itemDescriptionPopUp
                    width: 280
                    height: 200
                    x: 300
                    y: 155
                    font.pointSize: 14
                    smooth: true
                }

        }

        Pane {
            id: sideBar
            x: 962
            y: 0
            padding: 0
            width: 404
            height: 768
            Material.background: Style.basicColor3
            Material.elevation: 1

            TextField {
                id: customerName
                x: 16
                y: 81
                width: 294
                height: 43
                smooth: true
                text: qsTr("")
                font.pointSize: 16
                placeholderText: "Enter Your Name"
            }

            Text {
                id: sn
                x: 16
                y: 153
                color: Style.basicColor
                text: qsTr("SN")
                smooth: true
                font.pixelSize: 15
            }

            Text {
                id: listname
                x: 63
                y: 153
                width: 120
                height: 16
                color: Style.basicColor
                smooth: true
                text: qsTr("Name")
                font.pixelSize: 15
            }

            Text {
                id: listQt
                x: 206
                y: 153
                width: 17
                height: 16
                color: Style.basicColor
                smooth: true
                text: qsTr("Qt.")
                font.pixelSize: 15
            }

            Text {
                id: listPrice
                x: 259
                y: 153
                width: 38
                height: 16
                smooth: true
                color: Style.basicColor
                text: qsTr("Price")
                font.pixelSize: 15
            }

            Text {
                id: listTPrice
                x: 326
                y: 153
                width: 56
                height: 16
                color: Style.basicColor
                smooth: true
                text: qsTr("TotalPrice")
                font.pixelSize: 14
            }

            Rectangle {
                x: 0
                y: 183
                width: 398
                height: 585
                color: Style.thirdColor

                ListView {
                    x: 9
                    y: 0
                    width: 381
                    height: 307
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: orderList
                    delegate: ItemDelegate {
                        width: 381
                        height: 100
                        y: 80
                        Text {
                            x: 12
                            y: 10
                            width: 45
                            id: itemSn
                            text: index + 1
                            color: Style.basicColor
                            smooth: true
                            elide: Text.ElideRight
                            font.pointSize: 12
                            wrapMode: Text.Wrap
                        }
                        Text {
                            x: 53
                            y: 10
                            width: 135
                            id: itemName
                            text: model.name
                            color: Style.basicColor
                            smooth: true
                            font.pointSize: 13
                            wrapMode: Text.Wrap
                        }
                        Text {
                            x: 208
                            y: 10
                            id: itemQuantity
                            color: Style.basicColor
                            font.pointSize: 12
                            smooth: true
                            text: model.count
                        }
                        Text {
                            x: 230
                            y: 10
                            id: itemPrice
                            width: 60
                            color: Style.basicColor
                            font.pointSize: 12
                            smooth: true
                            text: model.price
                            horizontalAlignment: Text.AlignRight
                        }
                        Text {
                            id: itemTotalPrice
                            x: 325
                            y: 10
                            width: 45
                            color: Style.basicColor
                            smooth: true
                            font.pointSize: 12
                            text: model.totalprice
                            horizontalAlignment: Text.AlignRight
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                setOrder(model.name, model.id,
                                         parseInt(model.price),
                                         parseFloat(model.discount), 0)
                                calcTotal()
                                sortItems()
                            }
                        }
                    }
                }

                Text {
                    id: totalHook
                    x: 199
                    y: 324
                    color: "#000000"
                    text: qsTr("Total:")
                    smooth: true
                    font.pixelSize: 19
                }

                Text {
                    id: totalText
                    x: 290
                    y: 321
                    width: 74
                    height: 26
                    color: "#000000"
                    text: netTotal
                    smooth: true
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 20
                }

                Text {
                    id: discountHook
                    x: 168
                    y: 378
                    color: "#000000"
                    text: qsTr("Discount:")
                    smooth: true
                    font.pixelSize: 19
                }

                Text {
                    id: discountText
                    x: 289
                    y: 375
                    width: 74
                    height: 26
                    color: "#000000"
                    text: dAmt
                    font.pixelSize: 20
                    smooth: true
                    horizontalAlignment: Text.AlignRight
                }

                Text {
                    id: gtotalHook
                    x: 135
                    y: 430
                    color: "#000000"
                    text: qsTr("Grand Total:")
                    font.pixelSize: 20
                    smooth: true
                }

                Text {
                    id: gtotalText
                    x: 291
                    y: 430
                    width: 74
                    height: 26
                    color: "#000000"
                    text: gtotalN
                    font.pixelSize: 20
                    smooth: true
                    horizontalAlignment: Text.AlignRight
                }
            }
        }

        Image {
            id: makeOrderButton
            x: 1296
            y: 705
            width: 37
            height: 44
            fillMode: Image.PreserveAspectFit
            source: "resources/order.png"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    if (orderList.count === 0) {

                    } else {
                        makeOrder()
                    }
                }
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    parent.source = "resources/orderHover.png"
                }
                onExited: {
                    parent.source = "resources/order.png"
                }
            }
        }
    }
    Popup {
        id: endPopup
        x: 550
        y: 284
        width: 250
        padding: 0
        height: 200
        modal: true
        focus: true
        Text {
            y: 30
            width: 250
            horizontalAlignment: Text.AlignHCenter
            id: popUpText
            font.pointSize: 16
            text: "Your Order id is"
        }
        Text {
            width: 250
            height: 200
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            id: popUpId
            font.pointSize: 30
            text: newOrder
        }
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    }

    Rectangle {
        id: topBar
        x: 238
        y: 0
        width: 1128
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
                rootWindow.setX(rootWindow.x + 0.4 * dx)
            }
            onMouseYChanged: {
                var dy = mouseY - previousY
                rootWindow.setY(rootWindow.y + 0.4 * dy)
            }
        }

        Image {
            id: minimize
            source: "../../resources/minimize.png"
            x: 1058
            y: 0
            opacity: 1
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "../../resources/minimizehover.png"
                }
                onExited: {
                    parent.source = "../../resources/minimize.png"
                }
                onClicked: {
                    showMinimized()
                }
            }
        }
        Image {
            id: cross
            source: "../../resources/cross.png"
            x: 1093
            y: 0
            opacity: 1

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "../../resources/crosshover.png"
                }
                onExited: {
                    parent.source = "../../resources/cross.png"
                }
                onClicked: {
                    rootWindow.close()
                }
            }
        }
    }

}




/*##^##
Designer {
    D{i:0;formeditorZoom:0.6600000262260437}
}
##^##*/
