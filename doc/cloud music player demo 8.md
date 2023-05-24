## 八 音乐播放

### 36 获取音频链接并播放

- App.qml

```qml
//App.qml

...

import QtMultimedia 5.12

ApplicationWindow {

    id:window

    ...


    MediaPlayer{
        id:mediaPlayer
    }

}

```

- MusicListView.qml

```qml
//MusicListView.qml

...

Frame{

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
                            anchors.centerIn: parent
                            MusicIconButton{
                                iconSource: "qrc:/images/pause"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "播放"
                                onClicked: playMusic(index)
                            }
                            ...
                        }
                    }
                }

                ...

            }
        }
    }

    ...

    function playMusic(index = 0){
        //播放
        if(musicList.length<1) return
        var id = musicList[index].id
        if(!id) return
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var url = JSON.parse(reply).data[0].url
            if(!url) return
            mediaPlayer.source = url
            mediaPlayer.play()
        }

        http.onReplySignal.connect(onReply)
        http.connet("song/url?id="+id)
    }

}
```

### 37 设置音乐信息（歌名、歌手、封面）

```qml
//MusicListView.qml

...

Frame{

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
                            anchors.centerIn: parent
                            MusicIconButton{
                                iconSource: "qrc:/images/pause"
                                iconHeight: 16
                                iconWidth: 16
                                toolTip: "播放"
                                onClicked: {
                                    layoutBottomView.playList = musicList
                                    layoutBottomView.playMusic(index)
                                }
                            }
                            ...
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



- LayoutBottomView.qml

```qml
//LayoutBottomView.qml

...

//底部工具栏
Rectangle{

    property var playList: []
    property int current: 0

    ...

    RowLayout{
        ...
        
        Item{
            ...

            Text{
                id:nameText
                ...
            }
            Text{
                id:timeText
                ...
            }

            Slider{
                id:slider
                ...
            }
        }

        MusicRoundImage{
            id:musicCover
            width: 50
            height: 50
        }

        ...

    }

    function playMusic(index = 0){
        //获取播放链接
        getUrl(index)

    }
    function getUrl(index){
        //播放
        if(playList.length<index+1) return
        var id = playList[index].id
        if(!id) return
        
        //设置详情
        nameText.text = playList[index].name+"/"+playList[index].artist

        function onReply(reply){

            http.onReplySignal.disconnect(onReply)


            var url = JSON.parse(reply).data[0].url
            if(!url) return

            var cover = playList[index].cover
            if(cover.length<1) {
                //请求Cover
                getCover(id)
            }else{
                musicCover.imgSrc = cover
            }

            mediaPlayer.source = url
            mediaPlayer.play()
        }

        http.onReplySignal.connect(onReply)
        http.connet("song/url?id="+id)
    }

    function getCover(id){
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)

            var cover = JSON.parse(reply).songs[0].al.picUrl
            if(cover) musicCover.imgSrc = url

        }
        http.onReplySignal.connect(onReply)
        http.connet("song/detail?ids="+id)
    }

}
```

### 38 音乐播放进度条

- App.qml

```qml
//App.qml

...

ApplicationWindow {

    ...

    MediaPlayer{
        id:mediaPlayer

        onPositionChanged: {
            layoutBottomView.setSlider(0,duration,position)
        }
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
        ...
        Item{
            ...

            Slider{
                id:slider
                ...

                value: sliderValue
                from:sliderFrom
                to:sliderTo

                onMoved: {
                    mediaPlayer.seek(value)
                }

                ...
            }
        }

        ...

    }

    ...
    
    function getUrl(index){
        //播放
        ...
        function onReply(reply){

            http.onReplySignal.disconnect(onReply)

            var data = JSON.parse(reply).data[0]
            var url = data.url
            var time = data.time

            //设置Slider
            setSlider(0,time,0)

            ...
        }

        ...
    }

    function setSlider(from=0,to=100,value=0){
        sliderFrom = from
        sliderTo = to
        sliderValue = value

        var va_mm = parseInt(value/1000/60)+""
        va_mm = va_mm.length<2?"0"+va_mm:va_mm
        var va_ss = parseInt(value/1000%60)+""
        va_ss = va_ss.length<2?"0"+va_ss:va_ss

        var to_mm = parseInt(to/1000/60)+""
        to_mm = to_mm.length<2?"0"+to_mm:to_mm
        var to_ss = parseInt(to/1000%60)+""
        to_ss = to_ss.length<2?"0"+to_ss:to_ss

        timeText.text = va_mm+":"+va_ss+"/"+to_mm+":"+to_ss
    }

    ...

}
```

### 39 播放模式、切换上一曲、下一曲

- App.qml

```qml
//App.qml

...
import Qt.labs.settings 1.1

ApplicationWindow {

    ...

    Settings{
        id:settings
        fileName: "conf/settings.ini"
    }

    ...

    MediaPlayer{
        id:mediaPlayer

        ...

        onPlaybackStateChanged: {
            if(playbackState===MediaPlayer.StoppedState&&layoutBottomView.playbackStateChangeCallbackEnabled){
                layoutBottomView.playNext()
            }
        }
    }
}
```

- MusicListView.qml

```qml
//MusicListView.qml

...

Frame{

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
                            anchors.centerIn: parent
                            MusicIconButton{
                                ...
                                toolTip: "播放"
                                onClicked: {
                                    layoutBottomView.current = -1
                                    layoutBottomView.playList = musicList
                                    layoutBottomView.current = index
                                }
                            }
                            ...
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

- LayoutBottomView.qml

```qml
//LayoutBottomView.qml

...

//底部工具栏
Rectangle{

    ...
    property int current: -1

    ...

    property int currentPlayMode: 0
    property var playModeList: [
        {icon:"single-repeat",name:"单曲循环"},
        {icon:"repeat",name:"顺序播放"},
        {icon:"random",name:"随机播放"}]

    property bool playbackStateChangeCallbackEnabled: false

    ...



    RowLayout{
        anchors.fill: parent

        Item{
            Layout.preferredWidth: parent.width/10
            Layout.fillWidth: true
        }
        MusicIconButton{
            icon.source: "qrc:/images/previous"
            iconWidth: 32
            iconHeight: 32
            toolTip: "上一曲"
            onClicked: playPrevious()
        }
        MusicIconButton{
            iconSource: "qrc:/images/stop"
            iconWidth: 32
            iconHeight: 32
            toolTip: "暂停/播放"
        }
        MusicIconButton{
            icon.source: "qrc:/images/next"
            iconWidth: 32
            iconHeight: 32
            toolTip: "下一曲"
            onClicked: playNext("")
        }
        ...

    }

    Component.onCompleted: {
        //从配置文件中拿到currentPlayMode
        currentPlayMode =settings.value("currentPlayMode",0)
    }

    onCurrentChanged: {
        playbackStateChangeCallbackEnabled =false
        playMusic(current)
    }

    function playPrevious(){
        if(playList.length<1)return
        switch(currentPlayMode){
        case 0:
        case 1:
            current = (current+playList.length-1)%playList.length
            break
        case 2:{
            var random = parseInt(Math.random()*playList.length)
            current = current === random?random+1:random
            break
        }
        }
    }

    function playNext(type='natural'){
        if(playList.length<1)return
        switch(currentPlayMode){
        case 0:
            if(type==='natural'){
                mediaPlayer.play()
                break
            }
        case 1:
            current = (current+1)%playList.length
            break
        case 2:{
            var random = parseInt(Math.random()*playList.length)
            current = current === random?random+1:random
            break
        }
        }
    }

    function changePlayMode(){
        currentPlayMode = (currentPlayMode+1)%playModeList.length
        settings.setValue("currentPlayMode",currentPlayMode)
    }

    function playMusic(){
        if(current<0)return
        //获取播放链接
        getUrl()
    }
    function getUrl(){
        //播放
        if(playList.length<current+1) return
        var id = playList[current].id
        if(!id) return

        //设置详情
        nameText.text = playList[current].name+"/"+playList[current].artist

        function onReply(reply){
            ...
            var cover = playList[current].cover
            ...
        }

        ...
    }

    ...

}
```

