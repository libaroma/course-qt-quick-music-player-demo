## 九 音乐详情

### 40 自定义边框圆角图片

```qml
//MusicBorderImage.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Rectangle {
    property string imgSrc: "qrc:/images/player"
    property int borderRadius: 5
    property bool isRotating: false
    property real rotationAngel: 0.0

    radius:borderRadius

    gradient: Gradient{
        GradientStop{
            position: 0.0
            color: "#101010"
        }
        GradientStop{
            position: 0.5
            color: "#a0a0a0"
        }
        GradientStop{
            position: 1.0
            color: "#505050"
        }
    }

    MusicRoundImage{
        id:image
        imgSrc: imgSrc
        width: parent.width*0.9
        height: parent.height*0.9
        borderRadius: borderRadius
    }

    NumberAnimation{
        running: isRotating
        loops: Animation.Infinite
        target: image
        from:rotationAngel
        to:360+rotationAngel
        duration: 100000
        onStopped: {
            rotationAngel = mask.rotation
        }
    }
}
```

### 41 创建详情页面

- App.qml

```qml
//App.qml

...

ApplicationWindow {

    ...


    ColumnLayout{
        ...

        PageDetailView{
            id:pageDetailView
            visible: false
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

        MusicBorderImage{
            id:musicCover
            width: 50
            height: 45

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onPressed: {
                    musicCover.scale=0.9
                }
                onReleased:{
                    musicCover.scale=1.0
                }

                onClicked: {
                    pageDetailView.visible = ! pageDetailView.visible
                    pageHomeView.visible = ! pageHomeView.visible
                }
            }
        }

        ...

    }

    ...

}
```

- PageDetailView.qml

```qml
//PageDetailView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

Frame {
    Layout.fillHeight: true
    Layout.fillWidth: true

}
```

### 42 详情页面布局

- LayoutBottomView.qml

```qml
//LayoutBottomView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

//底部工具栏
Rectangle{

    ...

    property string musicName: "续加仪"
    property string musicArtist: "续加仪"
    property string musicCover:"qrc:/images/player"

    ...

    RowLayout{
        
        ...
        Item{
            ...

            Text{
                ...
                text:musicName+"-"+musicArtist
                ...
            }

            ...
        }

        MusicBorderImage{
            imgSrc: musicCover
            ...
        }

        ...

    }

    ...
    
    function getUrl(){
        ...

        //设置详情
        musicName = playList[current].name
        musicArtist = playList[current].artist

        function onReply(reply){

            ...
            
            if(cover.length<1) {
                //请求Cover
                getCover(id)
            }else{
                musicCover = cover
            }

            ...
        }

        ...
    }

    ...

    function getCover(id){
        function onReply(reply){
            ...
            if(cover) musicCover = cover

        }
        ...
    }

}
```

- PageDetailView.qml

```qml
//PageDetailView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    RowLayout{
        anchors.fill: parent
        Frame{
            Layout.preferredWidth: parent.width*0.45
            Layout.fillHeight: true


            Text {
                id: name
                text: layoutBottomView.musicName
                anchors{
                    bottom: artist.top
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 16
                }
            }

            Text {
                id: artist
                text: layoutBottomView.musicArtist
                anchors{
                    bottom: cover.top
                    bottomMargin: 50
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }
            }
            MusicBorderImage{
                id:cover
                anchors.centerIn: parent
                width: parent.width*0.6
                height: width
                borderRadius: width
                imgSrc: layoutBottomView.musicCover
                isRotating:  true
            }
        }

        Frame{
            Layout.preferredWidth: parent.width*0.55
            Layout.fillHeight: true
        }

    }
}
```

- MusicBorderImage.qml

```qml
//MusicBorderImage.qml

...

Rectangle {
    ...

    OpacityMask{
        id:maskImage
        ...
    }

    NumberAnimation{
        ...
        target: maskImage
        ...
        property: "rotation"
        ...
    }
}
```

### 43 音乐播放暂停

- App.qml

```qml
//App.qml

...

ApplicationWindow {

    ...

    MediaPlayer{
        ...
        onPlaybackStateChanged: {
            layoutBottomView.playingState = playbackState===MediaPlayer.PlayingState? 1:0

            ...
        }
    }

}

```

- LayoutBottomView.qml

```qml
//LayoutBottomView.qml

...
import QtMultimedia 5.12

//底部工具栏
Rectangle{

    ...

    property int playingState: 0

    ...

    RowLayout{
        ...
        MusicIconButton{
            iconSource: playingState===0?"qrc:/images/stop":"qrc:/images/pause"
            iconWidth: 32
            iconHeight: 32
            toolTip: "暂停/播放"
            onClicked: {
                if(!mediaPlayer.source) return
                if(mediaPlayer.playbackState===MediaPlayer.PlayingState){
                    mediaPlayer.pause()
                }else if(mediaPlayer.playbackState===MediaPlayer.PausedState){
                    mediaPlayer.play()
                }
            }
        }
        ...
    }

    ...

    function getCover(id){
        function onReply(reply){
            ...
            if(musicName.length<1)musicName = song.name
            if(musicArtist.length<1)musicArtist = song.ar[0].name

        }
        ...
    }
}
```

- MusicBannerView.qml

```qml
//MusicBannerView.qml

...

Frame{
    ...
    PathView{
        ...

        delegate: Item{
            ...

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if(bannerView.currentIndex === index){
                        var item  =bannerView.model[index]
                        var targetId = item.targetId+""
                        var targetType = item.targetType+"" //1:单曲,10:专辑,1000:歌单
                        switch(targetType){
                        case "1":
                            //播放歌曲
                            layoutBottomView.current = -1
                            layoutBottomView.playList=[{id:targetId,name:"",artist:"",cover:"",album:""}]
                            layoutBottomView.current = 0
                            break
                        ...
                        }
                        ...
                    }
                    ...
                }
            }
        }
        ...
    }
    ...
}
```

### 44 音乐播放暂停与唱片旋转绑定

- MusicBorderImage.qml

```qml
//MusicBorderImage.qml

...

Rectangle {
    ...

    NumberAnimation{
        ...
        onStopped: {
            rotationAngel = maskImage.rotation
        }
    }
}
```

- PageDetailView.qml

```qml
//PageDetailView.qml

...

Item {
    ...

    RowLayout{
        anchors.fill: parent
        Frame{
            ...
            MusicBorderImage{
                id:cover
                ...
                isRotating:  layoutBottomView.playingState===1
            }
        }
        ...
    }
}
```

### 45 自定义滚动歌词组件

- PageDetailView.qml

```qml
//PageDetailView.qml

...

Item {
    ...

    RowLayout{
        ...

        Frame{
            Layout.preferredWidth: parent.width*0.55
            Layout.fillHeight: true

            MusicLyricView{
                anchors.fill: parent
            }
        }
    }
}
```

- MusicLyricView.qml

```qml
//MusicLyricView.qml

import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQml 2.12

Rectangle {

    property alias lyrics: list.model
    property alias current: list.currentIndex

    id:lyricView

    Layout.preferredHeight:parent.height*0.8
    Layout.alignment: Qt.AlignHCenter

    clip: true

    ListView{
        id:list
        anchors.fill: parent
        model:["暂无歌词","续加仪","续加仪"]
        delegate: listDelegate
        highlight: Rectangle{
            color: "#2073a7db"
        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
        currentIndex: 0
        preferredHighlightBegin: parent.height/2-50
        preferredHighlightEnd: parent.height/2
        highlightRangeMode: ListView.StrictlyEnforceRange
    }

    Component{
        id:listDelegate
        Item{
            id:delegateItem
            width: parent.width
            height: 50
            Text{
                text:modelData
                anchors.centerIn: parent
                color: index===list.currentIndex?"black":"#505050"
                font.family: window.mFONT_FAMILY
                font.pointSize: 12

            }
            states:State{
                when:delegateItem.ListView.isCurrentItem
                PropertyChanges{
                    target: delegateItem
                    scale:1.2
                }
            }
            MouseArea{
                anchors.fill: parent
                onCanceled: list.currentIndex = index
            }
        }
    }

}

```

### 46 请求歌词及歌词内容解析

- LayoutBottomView.qml

```qml
//LayoutBottomView.qml

...

//底部工具栏
Rectangle{

    ...

    function getCover(id){
        function onReply(reply){
            ...
            //请求歌词
            getLyric(id)
            ...
        }
        ...
    }

    function getLyric(id){
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var lyric = JSON.parse(reply).lrc.lyric
            console.log(lyric)
            if(lyric.length<1) return
            var lyrics = (lyric.replace(/\[.*\]/gi,"")).split("\n")

            if(lyrics.length>0) pageDetailView.lyricsList = lyrics

            var times = []
            lyric.replace(/\[.*\]/gi,function(match,index){
                //match : [00:00.00]
                if(match.length>2){
                    var time  = match.substr(1,match.length-2)
                    var arr = time.split(":")
                    var timeValue = arr.length>0? parseInt(arr[0])*60*1000:0
                    arr = arr.length>1?arr[1].split("."):[0,0]
                    timeValue += arr.length>0?parseInt(arr[0])*1000:0
                    timeValue += arr.length>1?parseInt(arr[1])*10:0

                    times.push(timeValue)
                }
            })
        }
        http.onReplySignal.connect(onReply)
        http.connet("lyric?id="+id)
    }
}
```

- PageDetailView.qml

```qml
//PageDetailView.qml

...

Item {
    ...

    property alias lyricsList : lyricView.lyrics

    ...
}
```

### 47 歌词滚动

- App.qml

```qml
//App.qml

...

ApplicationWindow {
    
    ...
    
    MediaPlayer{
        id:mediaPlayer
        
        property var times: []
        
        onPositionChanged: {
            ...
            if(times.length>0){
                var count = times.filter(time=>time<position).length
                pageDetailView.current  = (count===0)?0:count-1
            }
        }
        ...
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

    function getLyric(id){
        function onReply(reply){
            ...

            var times = []
            ...

            mediaPlayer.times = times

        }
        ...
    }
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

    ...
}
```

