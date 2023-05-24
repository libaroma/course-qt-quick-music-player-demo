//MusicNotification.qml

import QtQuick 2.12
import QtGraphicalEffects 1.0
import QtQml 2.12

Item {

    property Item parentWindow: parent

    id:self

    visible: false
    scale: visible

    width: 400
    height: 50

    anchors{
        top:parentWindow.top
        topMargin: 45
        horizontalCenter: parentWindow.horizontalCenter
    }
    DropShadow{
        anchors.fill: rect
        radius: 8
        horizontalOffset: 1
        verticalOffset:1
        samples: 16
        color: "#60000000"
        source: rect
    }

    Rectangle{
        id:rect
        color: "#03a9f4"
        radius: 5
        anchors.fill: parent

        Text{
            id:content
            text:"Notification..."
            color: "#eeffffff"
            font{
                family: window.mFONT_FAMILY
                pointSize: 11
            }
            width: 350
            lineHeight: 25
            lineHeightMode: Text.FixedHeight
            wrapMode: Text.WordWrap
            anchors{
                left:parent.left
                leftMargin: 10
                verticalCenter: parent.verticalCenter
            }
        }
        MusicIconButton{
            iconSource: "qrc:/images/clear"
            iconWidth: 16
            iconHeight: 16
            toolTip: "关闭"
            anchors{
                right: parent.right
                rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            onClicked: close()
        }
    }

    Behavior on scale {
        NumberAnimation{
            easing.type: Easing.InOutQuad
            duration: 100
        }
    }


    Timer{
        id:timer
        interval: 3000
        onTriggered: close()
    }


    function open(text="Notification..."){
        close()
        content.text = text
        visible = true
        timer.start()

    }

    function openSuccess(text="Notification..."){
        rect.color = "#4caf50"
        open(text)
    }
    function openError(text="Notification..."){
        rect.color = "#ff5252"
        open(text)
    }
    function openWarning(text="Notification..."){
        rect.color = "#f57c00"
        open(text)
    }
    function openInfo(text="Notification..."){
        rect.color = "#03a9f4"
        open(text)
    }

    function close(){
        visible = false
        timer.stop()
    }

}
