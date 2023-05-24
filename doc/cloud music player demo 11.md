## 十一 播放历史

### 52 播放历史页面布局

```qml
//DetailHistoryPageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQml 2.12

ColumnLayout{

    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("历史播放")
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
            btnText: "刷新记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: getHistory()
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: clearHistory()
        }

    }

    MusicListView{
        id:historyListView
    }

    ...

}
```

### 53 保存和清空播放历史


- App.qml

```qml
//App.qml

...

import Qt.labs.settings 1.1

ApplicationWindow {
    ...

    Settings{
        id:historySettings
        fileName: "conf/history.ini"
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

    function saveHistory(index = 0){
        if(playList.length<index+1) return
        var item  = playList[index]
        var history =  historySettings.value("history",[])
        var i =  history.findIndex(value=>value.id===item.id)
        if(i>=0){
            history.slice(i,1)
        }
        history.unshift({
                            id:item.id+"",
                            name:item.name+"",
                            artist:item.artist+"",
                            url:item.url?item.url:"",
                            type:item.type?item.type:"",
                            album:item.album?item.album:"本地音乐"
                        })
        if(history.length>500){
            //限制五百条数据
            history.pop()
        }
        historySettings.setValue("history",history)
    }

    ...

    function playMusic(){
        if(current<0)return
        if(playList.length<current+1) return
        ...
        saveHistory(current)

    }
    ...

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
    }

    Component.onCompleted: {
        getHistory()
    }

    function getHistory(){
        historyListView.musicList = historySettings.value("history",[])
    }

    function clearHistory(){
        historySettings.setValue("history",[])
        getHistory()
    }

}

```