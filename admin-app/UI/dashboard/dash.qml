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
    signal setQMLSources(string path)
    Material.accent: "#ff704b"
    property string yesterdaySales: ""
    property string yesterdayBest: ""
    property string allTimeBest: ""
    property string weekSales: ""
    property string monthSales: ""
    property string pending: ""
    property string sdate: JSON.parse(sql.getSalesBound())[0].date
    property string edate: JSON.parse(sql.getSalesBound())[1].date

    JSONListModel{
        id: yesterday
        json: sql.getDashStats(yesterdayDate,yesterdayDate)
    }
    JSONListModel{
        id: week
        json: sql.getDashStats(weekStart,weekEnd)
    }
    JSONListModel{
        id: month
        json: sql.getDashStats(monthStart,monthEnd)
    }
    JSONListModel{
        id: pendingInfo
        json: sql.getOrderCount("0")
    }
    JSONListModel{
        id: alltime
        json: if(sdate!= "" && edate!= ""){
                  sql.getDashStats(sdate,edate)
              }else{
                json = "";
              }
    }
    Component.onCompleted: {
        if(yesterday.json!=""){
            yesterdaySales = yesterday.mo[0].total
            yesterdayBest = JSON.parse(sql.getMenuItem("*","id",yesterday.mo[0].best))[0].name
        }
        if(week.json!=""){
            weekSales = week.mo[0].total
        }
        if(month.json!=""){
            monthSales = month.mo[0].total
        }
        if(alltime.json !=""){
            allTimeBest = JSON.parse(sql.getMenuItem("*","id", alltime.mo[0].best))[0].name
        }

        pending = pendingInfo.mo[0].count
    }
    Rectangle{
        x: 0
        y: 0
        width: 1268
        height: 752
        color: Style.backgroundColor
        radius: 25
        smooth: true
        Rectangle {
            id: yesterdaySpot
            x: 69
            y: 32
            width: 353
            height: 240
            radius: 20
            color: Style.color1

            Text {
                id: yesterdayHook
                x: 12
                y: 35
                color: "#ffffff"
                text: qsTr("Yesterday Sales (Rs):")
                font.pixelSize: 18
            }

            Text{
                id: yesterdayS
                x: 46
                y: 158
                width: 297
                height: 58
                color: "#ffffff"
                text: yesterdaySales
                font.pointSize: 36
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignRight
            }
        }
        Rectangle {
            id: lastWeekSpot
            x: 468
            y: 32
            width: 323
            height: 240
            radius: 20
            color: Style.color2

            Text {
                id: lastWeekhook
                x: 17
                y: 35
                color: "#ffffff"
                text: qsTr("Last Week Sales (Rs):")
                font.pixelSize: 18
            }

            Text{
                id: lastWeekS
                x: 17
                y: 157
                width: 297
                height: 58
                color: "#ffffff"
                text: weekSales
                font.pointSize: 36
                horizontalAlignment: Text.AlignRight
            }

        }
        Rectangle {
            id: lastMonthSpot
            x: 834
            y: 32
            width: 353
            height: 240
            radius: 20
            color: Style.color3

            Text {
                id: lastMonthHook
                x: 24
                y: 35
                color: "#ffffff"
                text: qsTr("Last Month Sales (Rs):")
                font.pixelSize: 18
            }

            Text{
                id: lastMonthS
                x: 44
                y: 157
                width: 297
                height: 58
                color:"#ffffff"
                text: monthSales
                font.pointSize: 36
                horizontalAlignment: Text.AlignRight
            }

        }
        Rectangle {
            id: graphSpot
            x: 69
            y: 306
            width: 539
            height: 398
            color: Style.color4
        }

        Rectangle {
            id: yesterdayBestSellerSpot
            x: 678
            y: 290
            width: 509
            height: 216
            radius: 20
            color: Style.color5

            Text {
                id: yesterdaybestHook
                x: 24
                y: 38
                color: "#ffffff"
                text: qsTr("Yesterday's Best Seller")
                font.pixelSize: 18
            }

            Text {
                id: yesterdaybestS
                x: 39
                y: 86
                width: 422
                height: 106
                color: "#ffffff"
                text: yesterdayBest
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 37
            }
        }
        Rectangle {
            id: bestSellingItemSpot
            x: 678
            y: 527
            width: 247
            height: 177
            radius: 20
            color: Style.color6

            Text {
                id: bestSellingHook
                x: 19
                y: 29
                color: "#ffffff"
                text: qsTr("Best Selling Item")
                font.pixelSize: 18
            }

            Text {
                id: bestSellingS
                x: 14
                y: 62
                width: 220
                height: 101
                color: "#ffffff"
                text: allTimeBest
                elide: Text.ElideNone
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignLeft
                font.pixelSize: 34
            }
        }
        Rectangle {
            id: pendingOrderSpot
            x: 947
            y: 527
            width: 247
            height: 177
            radius: 20
            color: Style.color7

            Text {
                id: pedningHook
                x: 18
                y: 31
                color: "#ffffff"
                text: qsTr("Pending Orders:")
                font.pixelSize: 18
            }

            Text {
                id: pendingS
                x: 24
                y: 96
                width: 203
                height: 58
                color: "#ffffff"
                text: pending
                horizontalAlignment: Text.AlignRight
                font.pixelSize: 34
            }
        }


    }
}
