//MusicToolTip.qml

import QtQuick 2.12
import QtQuick.Window 2.12

Rectangle {

    property alias text: content.text
    property int margin: 15

    id:self
    z:4

    color: "white"
    radius: 4
    width: content.width+20
    height: content.height+20

    anchors{
        top:getGlobalPositon(parent).y+parent.height+margin+height<Window.height?parent.bottom:undefined
        bottom:getGlobalPositon(parent).y+parent.height+margin+height>=Window.height?parent.top:undefined
        left: (width-parent.width)/2>getGlobalPositon(parent).x?parent.left:undefined
        right:width+getGlobalPositon(parent).x>Window.width?parent.right:undefined
        topMargin: margin
        bottomMargin: margin
    }

    x:(width-parent.width)/2<=parent.x&&width+parent.x<=Window.width?(-width+parent.width)/2:0

    Text{
        id:content
        text: "这是一段提示文字！"
        lineHeight: 1.2
        anchors.centerIn: parent
        font.family: window.mFONT_FAMILY
    }

    function getGlobalPositon(target=parent){
        var targetX = 0
        var targetY = 0
        while(target!==null){
            targetX += target.x
            targetY += target.y
            target  = target.parent
        }
        return {
            x:targetX,
            y:targetY
        }
    }

}
