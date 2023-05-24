## 十 本地音乐

### 48 本地音乐页面布局

- DetailLocalPageView.qml

```qml
//DetailLocalPageView.qml

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
            text: qsTr("本地音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
        }
    }

    RowLayout{
        height: 80
        Item{
            width: 5
        }

        MusicTextButton{
            btnText: "添加本地音乐"
            btnHeight: 50
            btnWidth: 200
            onClicked: {

            }
        }
        MusicTextButton{
            btnText: "刷新记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: {

            }
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: {

            }
        }

    }

    MusicListView{
        id:localListView
    }
}
```

- MusicTextButton.qml

```qml
//MusicTextButton.qml

import QtQuick 2.12
import QtQuick.Controls 2.5

Button{
    property alias btnText: self.text


    property alias isCheckable:self.checkable
    property alias isChecked:self.checked

    property alias btnWidth: self.width
    property alias btnHeight: self.height

    id:self

    text: "Button"

    font.family: window.mFONT_FAMILY
    font.pointSize: 14

    background: Rectangle{
        implicitHeight: self.height
        implicitWidth: self.width
        color: self.down||(self.checkable&&self.checked)?"#e2f0f8":"#66e9f4ff"
        radius: 3
    }
    width: 50
    height: 50
    checkable: false
    checked: false
}
```

### 49 添加本地音乐

```qml
//DetailLocalPageView.qml

...
import Qt.labs.platform 1.0

ColumnLayout{

    ...

    RowLayout{
        ...

        MusicTextButton{
            ...
            onClicked:fileDialog.open()
        }
        ...

    }

    ...

    FileDialog{
        id:fileDialog
        fileMode: FileDialog.OpenFiles
        nameFilters: ["MP3 Music Files(*.mp3)","FLAC MUsic Files(*.flac)"]
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        acceptLabel: "确定"
        rejectLabel: "取消"

        onAccepted: {
            var list = []
            for(var index in files){
                var path = files[index]

                var arr = path.split("/")
                var fileNameArr = arr[arr.length-1].split(".")
                //去掉后缀
                fileNameArr.pop()
                var fileName = fileNameArr.join(".")
                //歌手-名称.mp3
                var nameArr = fileName.split("-")
                var name = "续加仪"
                var artist = "续加仪"
                if(nameArr.length>1){
                    artist = nameArr[0]
                    nameArr.shift()
                }
                name = nameArr.join("-")
                list.push({
                              id:path+"",
                              name,artist,
                              url:path+"",
                              album:"本地音乐",
                              type:"1"//1表示本地音乐，0表示网络
                          })
                localListView.musicList  = list
            }
        }
    }
}
```

### 50 播放本地音乐

```qml
//LayoutBottomView.qml

...

//底部工具栏
Rectangle{

    ...

    function playMusic(){
        if(current<0)return
        if(playList.length<current+1) return
        //获取播放链接
        if(playList[current].type==="1"){
            //播放本地音乐
            playLocalMusic()
        } else {
            //播放网络音乐
            playWebMusic()
        }

    }
    function playLocalMusic(){
        var currentItem = playList[current]
        mediaPlayer.source =currentItem.url
        mediaPlayer.play()
        musicName = currentItem.name
        musicArtist = currentItem.artist
    }

    function playWebMusic(){
        ...
    }

    ...
}
```

### 51 保存、刷新、清空本地音乐

```qml
//DetailLocalPageView.qml

...
import Qt.labs.settings 1.1
import QtQml 2.12

ColumnLayout{

    Settings{
        id:localSettings
        fileName: "conf/local.ini"
    }

    ...

    RowLayout{
        ...
        
        MusicTextButton{
            btnText: "刷新记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: getLocal()
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: saveLocal()
        }

    }

    MusicListView{
        id:localListView
    }

    Component.onCompleted: {
        getLocal()
    }

    function getLocal(){
        var list = localSettings.value("local",[])
        localListView.musicList = list
        return list
    }

    function saveLocal(list=[]){
        localSettings.setValue("local",list)
        getLocal()
    }

    FileDialog{
        ...

        onAccepted: {
            var list = getLocal()
            for(var index in files){
                ...
                if(list.filter(item=>item.id === path).length<1)
                    list.push({
                                  id:path+"",
                                  name,artist,
                                  url:path+"",
                                  album:"本地音乐",
                                  type:"1"//1表示本地音乐，0表示网络
                              })

                saveLocal(list)
            }
        }
    }
}
```

