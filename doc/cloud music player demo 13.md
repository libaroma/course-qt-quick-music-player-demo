## 十三 项目完善

### 56 删除记录

- MusicListView.qml

```qml
//MusicListView.qml

...

Frame{

    ...

    property bool deletable: true
    property bool favoritable: true

    ...
    signal deleteItem(int index)
    ...

    Component{
        id:listViewDelegate
        Rectangle{
            ...

            MouseArea{
                RowLayout{
                    ...
                    Item{
                        Layout.preferredWidth: parent.width*0.15
                        RowLayout{
                            ...
                            MusicIconButton{
                                visible: favoritable
                                ...
                            }
                            MusicIconButton{
                                visible: deletable
                                ...
                                toolTip: "删除"
                                onClicked: deleteItem(index)
                            }
                        }
                    }
                }

                ...

            }
        }
    }

    ...

}

```

- DetailFavoritePageView.qml

```qml
//DetailFavoritePageView.qml

...

ColumnLayout{

    ...

    MusicListView{
        id:favoriteListView
        favoritable: false
        onDeleteItem: deleteFavorite(index)
    }

    ...

    function deleteFavorite(index){
        var list =favoriteSettings.value("favorite",[])
        if(list.length<index+1)return
        list.splice(index,1)
        favoriteSettings.setValue("favorite",list)
        getFavorite()
    }

}
```

- DetailHistoryPageView.qml

```qml
//DetailHistoryPageView.qml

...

ColumnLayout{

    ...

    MusicListView{
        id:historyListView
        onDeleteItem: deleteHistory(index)
    }

    ...

    function deleteHistory(index){
        var list =historySettings.value("history",[])
        if(list.length<index+1)return
        list.splice(index,1)
        historySettings.setValue("history",list)
        getHistory()
    }
}
```

- DetailLocalPageView.qml

```qml
//DetailLocalPageView.qml

...

ColumnLayout{

    ...

    MusicListView{
        id:localListView
        onDeleteItem: deleteLocal(index)
    }

    ...

    function deleteLocal(index){
       var list =localSettings.value("local",[])
        if(list.length<index+1)return
        list.splice(index,1)
        saveLocal(list)
    }

    ...
}
```

- DetailPlayListPageView.qml

```qml
//DetailPlayListPageView.qml

...

ColumnLayout{

    ...

    MusicListView{
        id:playListListView
        deletable: false
    }

    ...
}

```

- DetailSearchPageView.qml

```qml
//DetailSearchPageView.qml

...

ColumnLayout{
    ...

    MusicListView{
        id:musicListView
        deletable: false
        onLoadMore:doSearch(offset,current)
        Layout.topMargin: 10
    }

    ...
}
```

### 57 全局背景

- Background.qml

```qml
//Background.qml

import QtQuick 2.12
import QtGraphicalEffects 1.0

Rectangle{

    property alias backgroundImageSrc:backgroundImage.source

    Image {
        id: backgroundImage
        source: "qrc:/images/player"
        anchors.fill:parent
        fillMode: Image.PreserveAspectCrop
    }

    ColorOverlay{
        id:backgroundImageOverlay
        anchors.fill:backgroundImage
        source: backgroundImage
        color: "#55000000"
    }

    FastBlur{
        anchors.fill: backgroundImageOverlay
        source: backgroundImageOverlay
        radius: 80
    }
}
```

- App.qml

```qml
//App.qml

...

ApplicationWindow {

    ...

    background: Background{
        id:appBackground
    }

    ...
}
```

### 58 修改颜色

- 文字：”#eeffffff“
- 背景：降低不透明度

### 59 播放详情页面背景切换

- Background.qml

```qml
//Background.qml
...

Rectangle{

    property bool showDefaultBackground: true

    Image {
        id: backgroundImage
        source: showDefaultBackground?"qrc:/images/player":layoutBottomView.musicCover
        ...
    }

    ...
}
```

- LayoutBottomView.qml

```qml
//LayoutBottomView.qml

...

//底部工具栏
Rectangle{

    ...

    RowLayout{
        ...

        MusicBorderImage{
            imgSrc: musicCover
            width: 50
            height: 45

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onPressed: {
                    musicCover.scale=0.9
                    pageDetailView.visible = ! pageDetailView.visible
                    pageHomeView.visible = ! pageHomeView.visible
                    appBackground.showDefaultBackground = !appBackground.showDefaultBackground
                }
                onReleased:{
                    musicCover.scale=1.0
                }
            }
        }

        ...

    }

    ...

}
```

### 60 去掉默认边框并实现窗口拖动

- App.qml

```qml
//App.qml

...

ApplicationWindow {

    ...

    flags: Qt.Window|Qt.FramelessWindowHint
}
```

- LayoutHeaderView.qml

```qml
//LayoutHeaderView.qml

...

ToolBar{

    property point point: Qt.point(x,y)

    ...
    RowLayout{
        ...
        Item{
            ...

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed:  setPoint(mouseX,mouseY)
                onMouseXChanged: moveX(mouseX)
                onMouseYChanged: moveY(mouseY)
            }
        }
        ...
    }

    ...
    
    function setPoint(mouseX =0 ,mouseY = 0){
        point =Qt.point(mouseX,mouseY)
        console.log(mouseX,mouseY)
    }

    function moveX(mouseX = 0 ){
        var x = window.x + mouseX-point.x
        if(x<-(window.width-70)) x = - (window.width-70)
        if(x>Screen.desktopAvailableWidth-70) x = Screen.desktopAvailableWidth-70
        window.x = x
    }
    function moveY(mouseY = 0 ){
        var y = window.y + mouseY-point.y
        if(y<=0) y = 0
        if(y>Screen.desktopAvailableHeight-70) y = Screen.desktopAvailableHeight-70
        window.y = y
    }
}
```

- LayoutBottomView.qml

```qml
//LayoutBottomView.qml

...

//底部工具栏
Rectangle{

    ...

    RowLayout{
        anchors.fill: parent

        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
            Layout.fillHeight:  true
            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: layoutHeaderView.setPoint(mouseX,mouseY)
                onMouseXChanged: layoutHeaderView.moveX(mouseX)
                onMouseYChanged: layoutHeaderView.moveY(mouseY)
            }
        }
        ...
        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
            Layout.fillHeight:  true

            MouseArea{
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onPressed: layoutHeaderView.setPoint(mouseX,mouseY)
                onMouseXChanged: layoutHeaderView.moveX(mouseX)
                onMouseYChanged: layoutHeaderView.moveY(mouseY)
            }
        }
    }
    ...
}
```

### 61 小窗播放

- LayoutHeaderView.qml

```qml
//LayoutHeaderView.qml

...

ToolBar{
    ...
    property bool isSmallWindow: false
    ...
    RowLayout{
        ...
        MusicToolButton{
            id:smallWindow
            iconSource: "qrc:/images/small-window"
            toolTip: "小窗播放"
            visible: !isSmallWindow
            onClicked: {
                isSmallWindow = true
                setWindowSize(330,650)
                pageHomeView.visible = false
                pageDetailView.visible = true
                appBackground.showDefaultBackground =  pageHomeView.visible
            }
        }
        MusicToolButton{
            id:normalWindow
            iconSource: "qrc:/images/exit-small-window"
            toolTip: "退出小窗播放"
            visible: isSmallWindow
            onClicked: {
                setWindowSize()
                isSmallWindow = false
                appBackground.showDefaultBackground =  pageHomeView.visible
            }
        }
        ...
    }
    ...
}
```

- LayoutBottomView.qml

```qml
//LayoutBottomView.qml

...

//底部工具栏
Rectangle{

    ...

    RowLayout{
        ...
        Item{
            visible: !layoutHeaderView.isSmallWindow
            ...
        }

        MusicBorderImage{
            visible: !layoutHeaderView.isSmallWindow
            ...
        }
        ...
    }
    ...
}
```

- PageDetailView.qml

```qml
//PageDetailView.qml

...

Item {
    ...

    property alias lyrics : lyricView.lyrics
    property alias current : lyricView.current

    RowLayout{
        anchors.fill: parent
        Frame{
            ...
    		Layout.fillWidth: true

            Text {
                id: lyric
                visible: layoutHeaderView.isSmallWindow
                text: lyricView.lyrics[lyricView.current]?lyricView.lyrics[lyricView.current]:"暂无歌词"
                anchors{
                    top: cover.bottom
                    topMargin: 50
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }
                color: "#aaffffff"
            }

        }

        Frame{
            visible: !layoutHeaderView.isSmallWindow
            ...
        }
    }
}
```

### 62 隐藏系统托盘

- AppSystemTrayIcon.qml

```qml
//AppSystemTrayIcon.qml
import Qt.labs.platform 1.0

SystemTrayIcon {
    id:systemTray
    visible: true
    iconSource: "qrc:/images/music"
    onActivated: {
        window.show()
        window.raise()
        window.requestActivate()
    }
    menu: Menu{
        id:menu
        MenuItem{
            text: "上一曲"
            onTriggered: layoutBottomView.playPrevious()
        }
        MenuItem{
            text: layoutBottomView.playingState===0?"播放":"暂停"
            onTriggered: layoutBottomView.playOrPause()
        }
        MenuItem{
            text: "下一曲"
            onTriggered: layoutBottomView.playNext()
        }
        MenuSeparator{}
        MenuItem{
            text: "显示"
            onTriggered: window.show()
        }
        MenuItem{
            text: "退出"
            onTriggered: Qt.quit()
        }
    }
}
```

- 

```qml
//App.qml

...

ApplicationWindow {

    ...

    AppSystemTrayIcon{

    }
}
```

### 63 自定义Notification通知

```qml
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
        rect.color = "#03a9f4"
        timer.stop()
    }

}
```

### 64 请求错误提示

- 

```qml
//App.qml

...

ApplicationWindow {

    ...

    MusicNotification{
        id:notification
    }
    ...

}
```

- DetailSearchPageView.qml

```qml
//DetailSearchPageView.qml

...

ColumnLayout{
    ...

    function doSearch(offset = 0,current = 0){

        var keywords = searchInput.text
        if(keywords.length<1)return
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length<1){
                    notification.openError("搜索结果为空！")
                    return
                }
                var result = JSON.parse(reply).result
                ...
            }catch(err){
                notification.openError("搜索结果出错！")
            }

        }
        http.onReplySignal.connect(onReply)
        http.connet("search?keywords="+keywords+"&offset="+offset+"&limit=60")
    }
}
```

### 65 Loading加载中提示

- MusicLoading.qml

```qml
//MusicLoading.qml

import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {

    property Item parentWindow: parent

    id:self

    visible: false
    scale: visible

    width:200
    height:180

    anchors.centerIn: parentWindow
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
        color: "#4003a9f4"
        radius: 5
        anchors.fill: parent

        Image{
            id:image
            source: "qrc:/images/loading"
            width: 50
            height: 50
            anchors.centerIn: parent
            NumberAnimation {
                property: "rotation"
                from:0
                to:360
                target: image
                loops:Animation.Infinite
                running: self.visible
                duration: 500
            }
        }

        Text{
            id:content
            text:"Loading..."
            color: "#eeffffff"
            font{
                family: window.mFONT_FAMILY
                pointSize: 11
            }
            anchors{
                top:image.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
        }
    }

    function open(){
        visible = true
    }

    function close(){
        visible = false
    }

}
```

- DetailSearchPageView.qml

```qml
//DetailSearchPageView.qml

...

ColumnLayout{
    ...

    function doSearch(offset = 0,current = 0){
        loading.open()
        ...
        function onReply(reply){
            loading.close()
            ...
        }
        ...
    }
}
```

### 66 最新歌曲播放

```qml
//MusicGridLatestView.qml

...

Item{

    property alias list: gridRepeater.model

    Grid{
        ...
        Repeater{
            id:gridRepeater
            Frame{
                ...

                MouseArea{
                    ...
                    onClicked: {
                        layoutBottomView.current = -1
                        layoutBottomView.playList = [{
                                                         id:list[index].id,
                                                         name:list[index].name,
                                                         artist:list[index].artists[0].name,
                                                         album:list[index].album.name,
                                                         cover:list[index].album.picUrl,
                                                         type:"0"
                                                     }]
                        layoutBottomView.current = 0
                    }
                }
            }
        }
    }
}
```

### 67 隐藏顶部和底部工具栏

```qml
//PageDetailView.qml

...

Item {
    ...

    RowLayout{
        anchors.fill: parent
        Frame{
            ...

            MouseArea{
                id:mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: displayHeaderAndBottom(false)
                onExited: displayHeaderAndBottom(true)
                onMouseXChanged: {
                    timer.stop()
                    cursorShape = Qt.ArrowCursor
                    timer.start()
                }
                onClicked: {
                    displayHeaderAndBottom(true)
                    timer.stop()
                }
            }
        }

        ...

    }

    Timer{
        id:timer
        interval: 3000
        onTriggered: {
            mouseArea.cursorShape = Qt.BlankCursor
            displayHeaderAndBottom(false)
        }
    }

    function displayHeaderAndBottom(visible = true){
        layoutHeaderView.visible = pageHomeView.visible||visible
        layoutBottomView.visible = pageHomeView.visible||visible
    }


}

```

### 68 自定义ToolTipⅠ

```qml
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
```

### 69 自定义ToolTipⅡ

```qml
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
        top:getGlobalPosition(parent).y+parent.height+margin+height<Window.height?parent.bottom:undefined
        bottom:getGlobalPosition(parent).y+parent.height+margin+height>=Window.height?parent.top:undefined
        left: (width-parent.width)/2>getGlobalPosition(parent).x?parent.left:undefined
        right:width+getGlobalPosition(parent).x>Window.width?parent.right:undefined
        topMargin: margin
        bottomMargin: margin
    }

    x:(width-parent.width)/2<=getGlobalPosition(parent).x&&width+getGlobalPosition(parent).x<=Window.width?(-width+parent.width)/2:0

    Text{
        id:content
        text: "这是一段提示文字！"
        lineHeight: 1.2
        anchors.centerIn: parent
        font.family: window.mFONT_FAMILY
    }


    function getGlobalPosition(targetObject) {
        var positionX = 0
        var positionY = 0
        var obj = targetObject        /* 遍历所有的父窗口 */
        while (obj !== null) {        /* 累加计算坐标 */
            positionX += obj.x
            positionY += obj.y
            obj = obj.parent
        }
        return {"x": positionX, "y": positionY}
    }

}
```



### 毛玻璃背景

```qml
    Rectangle{
        z:200
        x:parent.width/2-50
        y:parent.height/2-100
        width: 300
        height: 300
        clip:  true

        FastBlur{
            x:layout.x-parent.x
            y:layout.y-parent.y
            source: appBackground
            width: source.width
            height:source.height
            radius: 60
        }
        FastBlur{
            x:layout.x-parent.x
            y:layout.y-parent.y
            source: layout
            width: source.width
            height:source.height
            radius: 60
        }
    }
```







