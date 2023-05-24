## 五 推荐内容

### 19 简易堆叠轮播图Ⅰ

- DetailRecommendPageView.qml

```qml
//DetailRecommendPageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12


ScrollView{
    clip: true
    ColumnLayout {

        Text {
            text: qsTr("推荐内容")
            font.family: window.mFONT_FAMILY
            font.pointSize: 18
        }

        MusicBannerView{
            id:bannerView
            Layout.preferredWidth: window.width-200
            Layout.preferredHeight: (window.width-200)*0.3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component.onCompleted: {
        getBannerList()
    }

    function getBannerList(){

        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var banners = JSON.parse(reply).banners
            bannerView.bannerList = banners
        }

        http.onReplySignal.connect(onReply)
        http.connet("banner")
    }
}
```

- MusicBannerView.qml

```qml
//MusicBannerView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5

Frame{
    property int current: 0
    property var bannerList: []

    MusicRoundImage{
        id:leftImage
        width:parent.width*0.6
        height: parent.height*0.8
        anchors{
            left: parent.left
            bottom: parent.bottom
            bottomMargin: 20
        }

        imgSrc: getLeftImgSrc()
    }

    MusicRoundImage{
        id:centerImage
        width:parent.width*0.6
        height: parent.height
        z:2
        anchors.centerIn: parent
        imgSrc: getCenterImgSrc()
    }

    MusicRoundImage{
        id:rightImage
        width:parent.width*0.6
        height: parent.height*0.8
        anchors{
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }
        imgSrc: getRightImgSrc()
    }

    function getLeftImgSrc(){
        return bannerList.length?bannerList[(current-1+bannerList.length)%bannerList.length].imageUrl:""
    }
    function getCenterImgSrc(){
        return bannerList.length?bannerList[current].imageUrl:""
    }
    function getRightImgSrc(){
        return bannerList.length?bannerList[(current+1+bannerList.length)%bannerList.length].imageUrl:""
    }
}
```

### 20 简易堆叠轮播图Ⅱ

- MusicBannerView.qml

```qml
//MusicBannerView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Frame{
    property int current: 0
    property var bannerList: []


    background: Rectangle{
        color: "#00000000"
    }

    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: {
            bannerTimer.stop()
        }
        onExited: {
            bannerTimer.start()
        }
    }

    MusicRoundImage{
        id:leftImage
        width:parent.width*0.6
        height: parent.height*0.8
        anchors{
            left: parent.left
            bottom: parent.bottom
            bottomMargin: 20
        }

        imgSrc: getLeftImgSrc()

        onImgSrcChanged: {
            leftImageAnim.start()
        }

        NumberAnimation{
            id:leftImageAnim
            target: leftImage
            property: "scale"
            from: 0.8
            to:1.0
            duration: 200
        }

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if(bannerList.length>0)
                    current = current==0?bannerList.length-1:current-1
            }
        }
    }

    MusicRoundImage{
        id:centerImage
        width:parent.width*0.6
        height: parent.height
        z:2
        anchors.centerIn: parent
        imgSrc: getCenterImgSrc()

        onImgSrcChanged: {
            centerImageAnim.start()
        }
        NumberAnimation{
            id:centerImageAnim
            target: centerImage
            property: "scale"
            from: 0.8
            to:1.0
            duration: 200
        }

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
        }
    }


    MusicRoundImage{
        id:rightImage
        width:parent.width*0.6
        height: parent.height*0.8
        anchors{
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 20
        }
        imgSrc: getRightImgSrc()

        onImgSrcChanged: {
            rightImageAnim.start()
        }

        NumberAnimation{
            id:rightImageAnim
            target: rightImage
            property: "scale"
            from: 0.8
            to:1.0
            duration: 200
        }

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if(bannerList.length>0)
                    current = current==bannerList.length-1?0:current+1
            }
        }
    }
    PageIndicator{
        anchors{
            top:centerImage.bottom
            horizontalCenter: parent.horizontalCenter
        }
        count: bannerList.length
        interactive: true
        onCurrentIndexChanged: {
            current = currentIndex
        }
        delegate: Rectangle{
            width:20
            height: 5
            radius: 5
            color: current===index?"balck":"gray"
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered: {
                    bannerTimer.stop()
                    current = index
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }

    }

    Timer{
        id:bannerTimer
        running: true
        interval: 5000
        repeat: true
        onTriggered: {
            if(bannerList.length>0)
                current = current==bannerList.length-1?0:current+1
        }
    }


    ...
}
```



### 21 PathView动效堆叠轮播图Ⅰ

- MusicBannerView.qml

```qml
//MusicBannerView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Frame{
    property int current: 0
    property alias bannerList : bannerView.model


//    background: Rectangle{
//        color: "#00000000"
//    }
    PathView{
        id:bannerView
        width: parent.width
        height: parent.height

        clip: true

        delegate: Item{
            id:delegateItem
            width:bannerView.width*0.7
            height: bannerView.height
            z:PathView.z
            scale: PathView.scale

            MusicRoundImage{
                id:image
                imgSrc:modelData.imageUrl
                width: delegateItem.width
                height: delegateItem.height
            }
        }

        pathItemCount: 3
        path:bannerPath
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
    }

    Path{
        id:bannerPath
        startX: 0
        startY:bannerView.height/2

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}

        PathLine{
            x:bannerView.width/2
            y:bannerView.height/2
        }

        PathAttribute{name:"z";value:2}
        PathAttribute{name:"scale";value:0.85}

        PathLine{
            x:bannerView.width
            y:bannerView.height/2
        }

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}
    }
}
```

### 22 PathView动效堆叠轮播图Ⅱ

```qml
//MusicBannerView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Frame{
    property int current: 0
    property alias bannerList : bannerView.model


    background: Rectangle{
        color: "#00000000"
    }
    PathView{
        id:bannerView
        width: parent.width
        height: parent.height

        clip: true

        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: {
                bannerTimer.stop()
            }
            onExited: {
                bannerTimer.start()
            }
        }

        delegate: Item{
            id:delegateItem
            width:bannerView.width*0.7
            height: bannerView.height
            z:PathView.z?PathView.z:0
            scale: PathView.scale?PathView.scale:1.0

            MusicRoundImage{
                id:image
                imgSrc:modelData.imageUrl
                width: delegateItem.width
                height: delegateItem.height
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(bannerView.currentIndex === index){

                    }else{
                        bannerView.currentIndex = index
                    }
                }
            }
        }

        pathItemCount: 3
        path:bannerPath
        preferredHighlightBegin: 0.5
        preferredHighlightEnd: 0.5
    }

    Path{
        id:bannerPath
        startX: 0
        startY:bannerView.height/2-10

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}

        PathLine{
            x:bannerView.width/2
            y:bannerView.height/2-10
        }

        PathAttribute{name:"z";value:2}
        PathAttribute{name:"scale";value:0.85}

        PathLine{
            x:bannerView.width
            y:bannerView.height/2-10
        }

        PathAttribute{name:"z";value:0}
        PathAttribute{name:"scale";value:0.6}
    }

    PageIndicator{
        id:indicator
        anchors{
            top:bannerView.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: -10
        }
        count: bannerView.count
        currentIndex: bannerView.currentIndex
        spacing: 10
        delegate: Rectangle{
            width: 20
            height: 5
            radius: 5
            color: index===bannerView.currentIndex?"balck":"gray"
            Behavior on color{
                ColorAnimation {
                    duration: 200
                }
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    bannerTimer.stop()
                    bannerView.currentIndex = index
                }
                onExited: {
                    bannerTimer.start()
                }
            }
        }
    }

    Timer{
        id:bannerTimer
        running: true
        repeat: true
        interval: 3000
        onTriggered: {
            if(bannerView.count>0)
                bannerView.currentIndex=(bannerView.currentIndex+1)%bannerView.count
        }
    }
}
```

### 23 Grid网格显示热门歌单

- DetailRecommendPageView.qml

```qml
//DetailRecommendPageView.qml

...

ScrollView{
    clip: true
    ColumnLayout {

        ...

        Rectangle{

            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("热门歌单")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
            }
        }

        MusicGridHotView{
            id:hotView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-250)*0.2*4+30*4+20
            Layout.bottomMargin: 20
        }
    }

    ...

    function getBannerList(){

        function onReply(reply){
            ...
            
            getHotList()
        }

        ...
    }

    function getHotList(){

        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var playlists = JSON.parse(reply).playlists
            hotView.list =playlists
        }

        http.onReplySignal.connect(onReply)
        http.connet("top/playlist/highquality?limit=20")
    }
}
```

- MusicGridHotView.qml

```qml
//MusicGridHotView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Item{

    property alias list: gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill:parent
        columns: 5
        Repeater{
            id:gridRepeater
            Frame{
                padding: 5
                width: parent.width*0.2
                height: parent.width*0.2+30
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }
                clip: true

                MusicRoundImage{
                    id:img
                    width: parent.width
                    height: parent.width
                    imgSrc: modelData.coverImgUrl

                }

                Text{
                    anchors{
                        top:img.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    text:modelData.name
                    font.family: window.mFONT_FAMILY
                    height:30
                    elide: Qt.ElideMiddle
                }


                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50000000"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                }
            }
        }
    }
}
```

### 24 Grid网格显示最新歌曲

```qml
//DetailRecommendPageView.qml
...

ScrollView{
    clip: true
    ColumnLayout {

        ...
        
        Rectangle{

            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("新歌推荐")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
            }
        }

        MusicGridLatestView{
            id:latestView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-230)*0.1*10+20
            Layout.bottomMargin: 20
        }

    }
    
    ...

    function getHotList(){

        function onReply(reply){
            ...
            getLatestList()
        }

        ...
    }
    function getLatestList(){

        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var latestList = JSON.parse(reply).data
            latestView.list =latestList.slice(0,30)
        }

        http.onReplySignal.connect(onReply)
        http.connet("top/song")
    }
}        
```

- MusicGridLatestView

```qml
//MusicGridLatestView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Item{

    property alias list: gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill:parent
        columns: 3
        Repeater{
            id:gridRepeater
            Frame{
                padding: 5
                width: parent.width*0.333
                height: parent.width*0.1
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }

                clip: true

                MusicRoundImage{
                    id:img
                    width: parent.width*0.25
                    height: parent.width*0.25
                    imgSrc: modelData.album.picUrl
                }

                Text{
                    id:name
                    anchors{
                        left: img.right
                        verticalCenter: parent.verticalCenter
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    text:modelData.album.name
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 11
                    height:30
                    width: parent.width*0.72
                    elide: Qt.ElideRight
                }
                Text{
                    anchors{
                        left: img.right
                        top: name.bottom
                        leftMargin: 5
                    }
                    text:modelData.artists[0].name
                    font.family: window.mFONT_FAMILY
                    height:30
                    width: parent.width*0.72
                    elide: Qt.ElideRight
                }


                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50000000"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                }
            }
        }
    }
}
```

