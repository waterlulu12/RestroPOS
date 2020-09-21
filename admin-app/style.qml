pragma Singleton
import QtQuick 2.0

QtObject{

    property int state : 0

    property string mainColor : {change()}
    property string secondaryColor :""
    property string menuSideB : ""
    property string icon : ""
    property string catbox : ""
    property string basicColor : ""
    property string basicColor2 : ""
    property string insideBlocks : ""
    property string borders : ""
    property string backgroundColor : ""
    property string accentColor : ""
    property string headColor : ""

    //Dash.qml
    property string color1: ""
    property string color2: ""
    property string color3: ""
    property string color4: ""
    property string color5: ""
    property string color6: ""
    property string color7: ""
    property string menuText: ""
    property string menuHighlight: ""

    function change(){
        if(state == 0){
            mainColor = "#011627"
            secondaryColor = "#061f33"
            menuSideB = "#404e68"
            icon = "night.png"
            catbox = "categoryBox.png"
            basicColor = "#000000"
            basicColor2 = "#ffffff"
            insideBlocks = "#000000"
            borders = "#000000"
            backgroundColor = "#ffffff"
            accentColor = "#ff5400"
            headColor = "#000000"
            color1 = "#E73F3B"
            color2 = "#FFC632"
            color3 = "#55A630"
            color4 = "#E5E5E5"
            color5 = "#232F5B"
            color6 = "#662E9B"
            color7 = "#ff5400"
            menuText = "#ffffff"
            menuHighlight = "#001524"
        }
        if(state == 1){
            mainColor = "#202225"
            secondaryColor = "#242527"
            menuSideB = "#242527"
            icon = "light.png"
            catbox = "categoryBox2.png"
            basicColor = "#ffffff"
            basicColor2 = "#242527"
            insideBlocks = "#242527"
            borders = "#2f3136"
            backgroundColor = "#2f3136"
            accentColor = "#242527"
            headColor = "#ff704b"
            menuText = "#ffffff"
        }
    }

}
