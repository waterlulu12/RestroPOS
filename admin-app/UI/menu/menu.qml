import QtQuick 2.12
import QtQml 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.0
import QtQuick.Controls.Material 2.12
import "../qmlComponets"
import "../../"

Item {
    signal setQMLSources(string path)
    property string cid: ""
    property string iid: ""
    property int cmod: 0
    property int imod: 0
    property int cf: 0
    property int hasfile: 0
    Material.accent: "#ff704b"
    function clearItemFlags(){
        imod = 0
        iid = 0
        hasfile = 0
        itemNameField.text = ""
        priceField.text = ""
        discountField.text = ""
        descriptionArea.text = ""
        imageFilePath.text = "No Image Selected"
    }
    function clearCategoryFlags(){
        cid = 0
        cmod = 0
        categoryIField.text = ""
    }
    function updateItem(){
        if(hasfile){
            var data = itemNameField.text + "," + priceField.text
                    + "," + sql.pkfind("menu_category", "category",categoryField.currentText) + "," + discountField.text
            sql.updateItem(iid,"name,price,category,discount",data,descriptionArea.text,imageFilePath.text)

        }else{
            var data2 = itemNameField.text + "," + priceField.text
                    + "," + sql.pkfind("menu_category", "category",categoryField.currentText) + "," + discountField.text
            sql.updateItem(iid,"name,price,category,discount",data2,descriptionArea.text)
        }
        imod = 0
    }
    function createItem(){
        var data3 = itemNameField.text + "," + priceField.text + "," + sql.pkfind("menu_category", "category",categoryField.currentText) + "," + discountField.text
        sql.createMenuItem(data3,descriptionArea.text,imageFilePath.text)
    }
    Rectangle {
        x: 0
        y: 0
        width: 1268
        height: 752
        radius: 25
        smooth: true
        color: Style.backgroundColor
        Rectangle{
            id: menuContainer
            x: 77
            y: 0
            width: 732
            height: 733
            color: Style.backgroundColor
            Image {
                id: menuHead
                x: 212
                y: 30
                source: "image-assets/menuHead.png"
            }
            Text {
                id: menuHeadText
                x: 90
                y: 18
                width: 634
                height: 85
                font.family: "Short Stack"
                color: Style.headColor
                text: "MENU"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: 52
            }
            ScrollView {
                id: categoryView
                x: 8
                y: 140
                width: 720
                height: 571
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AlwaysOff
                }
                ListView {
                    id: categoryModel
                    boundsBehavior: Flickable.StopAtBounds
                    clip: true
                    width: parent.width
                    height: parent.height

                    JSONListModel {
                        id: categoryModelList
                        json: sql.getCategory()
                    }
                    model: categoryModelList.model
                    delegate: ItemDelegate {
                        x:20
                        width: 680
                        height: 80
                        state: "close"
                        id: itemDelegate
                        Image {
                            id: categoryBox
                            x: 0
                            y: 0
                            width: 680
                            source: "../../resources/" + Style.catbox
                        }
                        Text {
                            Material.theme: Material.Dark
                            x: 40
                            y: 16
                            id: textBoxCategory
                            font.pointSize: 18
                            color: Style.basicColor
                            smooth: true
                            text: model.category
                        }
                        Image {
                            id: deleteCategoryButton
                            x: 585
                            y: 30
                            source: "image-assets/remove.png"
                            MouseArea {
                                x: 0
                                y: -16
                                width: 35
                                height: 35
                                id: categoryDMArea
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: parent.source = "image-assets/removeHover.png"
                                onExited: parent.source = "image-assets/remove.png"
                                onClicked: {
                                    sql.deleteCategory(model.id)
                                    setQMLSources("../menu/menu.qml")
                                }
                            }
                        }
                        Image {
                            id: editCategoryButton
                            x: 630
                            y: 20
                            source: "image-assets/edit.png"
                            MouseArea {
                                x: 0
                                width: 30
                                height: 35
                                id: categoryEMArea
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered: parent.source = "image-assets/editHover.png"
                                onExited: parent.source = "image-assets/edit.png"
                                onClicked: {
                                    categoryIField.text = model.category
                                    cid = model.id
                                    cmod = 1
                                }
                            }
                        }
                        MouseArea {
                            id: categoryMArea
                            x: 0
                            y: 0
                            width: 585
                            height: 80
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (parent.state == "close") {
                                    menuLoadID.json = sql.getMenuItem("*",
                                                                      "category",
                                                                      model.id)
                                    itemModel.height = menuLoadID.count * 62
                                    parent.height = itemDelegate.height + itemModel.height
                                    parent.state = "open"
                                } else {
                                    menuLoadID.json = ""
                                    parent.state = "close"
                                    parent.height = itemDelegate.height - itemModel.height
                                }
                            }
                        }
                        ListView {
                            y: 85
                            id: itemModel
                            JSONListModel {
                                id: menuLoadID
                                json: ""
                            }
                            model: menuLoadID.model
                            delegate: ItemDelegate {
                                Material.accent: "#000000"
                                width: 680
                                height: 60
                                id: menuItemDelegate
                                Text {
                                    x: 40
                                    y: 18
                                    width: 260
                                    elide: Text.ElideRight
                                    color: Style.basicColor
                                    text: model.name
                                    smooth: true
                                    font.family: "Ubuntu"
                                }
                                Text {
                                    x: 310
                                    y: 18
                                    color: Style.basicColor
                                    text: "Rs. " + model.price
                                    smooth: true
                                    font.family: "Ubuntu"
                                }
                                Image {
                                    id: deleteItemButton
                                    x: 580
                                    y: 28
                                    source: "image-assets/remove.png"
                                    MouseArea {
                                        id: itemsDMArea
                                        x: 0
                                        y: -16
                                        width: 30
                                        height: 35
                                        onEntered: parent.source = "image-assets/removeHover.png"
                                        onExited: parent.source = "image-assets/remove.png"
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                        onClicked: {
                                            sql.deleteItem(model.id)
                                            setQMLSources("../menu/menu.qml")
                                        }
                                    }
                                }
                                Image {
                                    id: editItemButton
                                    x: 630
                                    y: 15
                                    source: "image-assets/edit.png"
                                    MouseArea {
                                        id: itemsEMArea
                                        x: 0
                                        width: 30
                                        height: 35
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                        onEntered: parent.source = "image-assets/editHover.png"
                                        onExited: parent.source = "image-assets/edit.png"
                                        onClicked: {
                                            imod = 1
                                            iid = model.id
                                            itemNameField.text = model.name
                                            priceField.text = model.price
                                            discountField.text = model.discount
                                            descriptionArea.text = model.description
                                            cf = 1
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            id: categoryEdit
            x: 879
            y: 0
            width: 371
            height: 219
            color: Style.secondaryColor

            Text {
                id: categoryTitle
                x: 27
                y: 24
                color: "#ffffff"
                text: "CATEGORY"
                font.family: "Ubuntu"
                font.pixelSize: 24
            }

            Image {
                id: categoryLine
                x: 27
                y: 70
                source: "image-assets/line.png"
            }

            TextField {
                id: categoryIField
                x: 48
                y: 93
                width: 276
                height: 54
                color: "#ffffff"
                text: ""
                placeholderText: "Category Name"
                placeholderTextColor: "#707987"
            }

            Image {
                id: clearCategory
                x: 204
                y: 167
                source: "../../resources/clear.png"
                smooth: true
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "../../resources/clearHover.png"
                    }
                    onExited: {
                        parent.source = "../../resources/clear.png"
                    }
                    onClicked: {
                        clearCategoryFlags()
                    }
                }
            }

            Image {
                id: saveCategoryButton
                x: 280
                y: 167
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
                        if(categoryIField.text != ""){
                            if (cmod) {
                                sql.updateCategory(cid, "category", categoryIField.text)
                            } else {
                                sql.createCategory(categoryIField.text)
                            }
                            setQMLSources("../menu/menu.qml")
                        }
                    }
                }
            }
        }
        Rectangle {
            id: itemEdit
            x: 879
            y: 218
            width: 371
            height: 515
            color: Style.secondaryColor
            Text {
                id: itemTitle
                x: 27
                y: 25
                color: "#ffffff"
                text: "ITEMS"
                font.family: "Ubuntu"
                font.pixelSize: 24
            }
            Image {
                id: itemLine
                x: 27
                y: 74
                source: "image-assets/line.png"
            }
            TextField {
                id: itemNameField
                x: 48
                y: 96
                width: 276
                height: 54
                text: ""
                placeholderText: "Item Name"
                color: "#ffffff"
                placeholderTextColor: "#707987"
            }
            TextField {
                id: priceField
                x: 48
                y: 162
                width: 120
                height: 54
                color: "#ffffff"
                text: ""
                placeholderTextColor: "#707987"
                placeholderText: "Price"
            }
            TextField {
                id: discountField
                x: 204
                y: 162
                width: 120
                height: 54
                text: ""
                color: "#ffffff"
                placeholderTextColor: "#707987"
                placeholderText: "Discount"
            }
            ComboBox {
                id: categoryField
                x: 48
                y: 231
                width: 276
                height: 54
                function categoryPrinter() {
                    let a = []
                    let b = JSON.parse(sql.getCategory())
                    for (var item in b) {
                        if (cf == 1 && b[item]["id"] === JSON.parse(sql.getMenuItem("*", "id",iid))[0]["category"]){
                            currentIndex = item
                        }
                        a.push(b[item]["category"])
                    }
                    return a
                }
                model: categoryPrinter()
            }

            TextArea {
                id: descriptionArea
                x: 48
                y: 297
                width: 276
                height: 81
                color: "#ffffff"
                clip: true
                wrapMode: "WordWrap"
                placeholderText: "Description"
                placeholderTextColor: "#707987"
            }

            Text {
                id: imageFilePath
                x: 48
                y: 395
                width: 217
                height: 31
                text: "No Image Selected"
                verticalAlignment: Text.AlignVCenter
                color: "#707987"
                font.pixelSize: 14
                elide: Text.ElideRight
            }

            Image {
                id: addImageButton
                x: 287
                y: 395
                smooth: true
                source: "../../resources/plus.png"
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {parent.source = "../../resources/plusHover.png"}
                    onExited: {parent.source = "../../resources/plus.png"}
                    onClicked: fileLoader.source = "file.qml"
                }
            }
            Connections {
                target: fileLoader.item
                onFileDialog:{
                    fileLoader.source=path
                }
                onFilePath:{
                    imageFilePath.text = filePath.substr(8)
                    hasfile = 1
                }
            }
            Loader {
                id: fileLoader
                source: ""
            }

            Image {
                id: clearItem
                x: 204
                y: 453
                source: "../../resources/clear.png"
                smooth: true
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "../../resources/clearHover.png"
                    }
                    onExited: {
                        parent.source = "../../resources/clear.png"
                    }
                    onClicked: {
                        clearItemFlags()
                    }
                }
            }

            Image {
                id: saveItemButton
                x: 280
                y: 453
                width: 44
                height: 44
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
                        if(itemNameField.text != ""){
                            if(imod){
                                updateItem()
                            }else{
                                createItem()
                            }
                            setQMLSources("../menu/menu.qml")
                        }
                    }
                }
            }
        }
    }
}
