## 七 专辑歌单列表

### 33 专辑歌单页面布局

- DetailPlayListPageView.qml

```qml
//DetailPlayListPageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout{

    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("专辑/歌单")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
        }
    }

    RowLayout{
        height: 200
        width: parent.width
        MusicRoundImage{
            id:playListCover
            width: 180
            height: 180
            imgSrc: "https://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg"
        }

        Item{
            Layout.fillWidth: true
            height: parent.height

            Text{
                id:playListDesc
                text:"https://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpghttps://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpghttps://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpghttps://p1.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg"
                width: parent.width
                anchors.centerIn: parent
                wrapMode: Text.WrapAnywhere
                font.family: window.mFONT_FAMILY
                font.pointSize: 14
                maximumLineCount: 4
                elide: Text.ElideRight
                lineHeight: 1.5
            }
        }
    }

    MusicListView{
        id:playListListView
    }

}

```



- PageHomeView.qml

```qml
//PageHomeView.qml

...

RowLayout{

    property int defaultIndex: 0
    property var qmlList: [
        {icon:"recommend-white",value:"推荐内容",qml:"DetailRecommendPageView",menu:true},
        {icon:"cloud-white",value:"搜索音乐",qml:"DetailSearchPageView",menu:true},
        {icon:"local-white",value:"本地音乐",qml:"DetailLocalPageView",menu:true},
        {icon:"history-white",value:"播放历史",qml:"DetailHistoryPageView",menu:true},
        {icon:"favorite-big-white",value:"我喜欢的",qml:"DetailFavoritePageView",menu:true},
        {icon:"",value:"",qml:"DetailPlayListPageView",menu:false}]

    spacing: 0
    Frame{

        ...

        Component.onCompleted: {
//            menuViewModel.append(qmlList.filter(item=>item.menu))

//            var loader = repeater.itemAt(defaultIndex)
//            loader.visible = true
//            loader.source = qmlList[defaultIndex].qml+".qml"

//            menuView.currentIndex = defaultIndex
            showPlayList()
        }
    }

    ...

    function showPlayList(){
//        repeater.itemAt(menuView.currentIndex).visible = false
        var loader = repeater.itemAt(5)
        loader.visible = true
        loader.source = qmlList[5].qml+".qml"
    }

    function hidePlayList(){
//        repeater.itemAt(menuView.currentIndex).visible = true
        var loader = repeater.itemAt(5)
        loader.visible = false
    }
}
```

### 34 专辑歌单详情

```qml
//DetailPlayListPageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12

ColumnLayout{

    property string targetId: ""
    property string targetType:"10"//album,playlist/detail
    property string name: "-"

    onTargetIdChanged:{
        console.log(targetType)
        if(targetType=="10")loadAlbum()
        else if(targetType=="1000") loadPlayList()
    }

    ...

    function loadAlbum(){

        var url = "album?id="+(targetId.length<1?"32311":targetId)

        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var album = JSON.parse(reply).album
            var songs = JSON.parse(reply).songs
            playListCover.imgSrc = album.blurPicUrl
            playListDesc.text = album.description
            name = "-"+album.name
            playListListView.musicList= songs.map(item=>{
                                                      return {
                                                          id:item.id,
                                                          name:item.name,
                                                          artist:item.ar[0].name,
                                                          album:item.al.name
                                                      }
                                                  })
        }

        http.onReplySignal.connect(onReply)
        http.connet(url)
    }

    function loadPlayList(){

        var url = "playlist/detail?id="+(targetId.length<1?"32311":targetId)


        function onSongDetailReply(reply){
            http.onReplySignal.disconnect(onSongDetailReply)
            console.log(reply)
            var songs = JSON.parse(reply).songs
            playListListView.musicList= songs.map(item=>{
                                                      return {
                                                          id:item.id,
                                                          name:item.name,
                                                          artist:item.ar[0].name,
                                                          album:item.al.name
                                                      }
                                                  })
        }

        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var playlist = JSON.parse(reply).playlist
            playListCover.imgSrc = playlist.coverImgUrl
            playListDesc.text = playlist.description
            name = "-"+playlist.name
            var ids = playlist.trackIds.map(item=>item.id).join(",")
            console.log(ids)
            http.onReplySignal.connect(onSongDetailReply)
            http.connet("song/detail?ids="+ids)

        }
        http.onReplySignal.connect(onReply)
        http.connet(url)
    }
}
```



```qml
//PageHomeView.qml

...

RowLayout{
    ...

    function showPlayList(targetId="",targetType="10"){
        repeater.itemAt(menuView.currentIndex).visible = false
        var loader = repeater.itemAt(5)
        loader.visible = true
        loader.source = qmlList[5].qml+".qml"
        loader.item.targetType=targetType
        loader.item.targetId=targetId
    }

    function hidePlayList(){
        repeater.itemAt(menuView.currentIndex).visible = true
        var loader = repeater.itemAt(5)
        loader.visible = false
    }
}
```





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
                            break
                        case "10":
                            //打开专辑
                        case "1000":
                            //打开播放列表
                            pageHomeView.showPlayList(targetId,targetType)
                            break
                        }

                        console.log(targetId,targetType)
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

### 35 推荐歌单详情

```qml
//MusicGridHotView.qml

...

Item{

    ...
    Grid{
        ...
        Repeater{
            id:gridRepeater
            Frame{
                ...

                MouseArea{
                    ...
                    onClicked: {
                        var item  =gridRepeater.model[index]
                        pageHomeView.showPlayList(item.id,"1000")
                    }
                }
            }
        }
    }
}
```

