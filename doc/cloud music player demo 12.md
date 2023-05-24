## 十二 我喜欢的

### 54 我喜欢的页面布局

- App.qml

```qml
//App.qml

...

ApplicationWindow {

    ...

    Settings{
        id:favoriteSettings
        fileName: "conf/favorite.ini"
    }

    ...

}
```

- DetailFavoritePageView.qml

```qml
//DetailFavoritePageView.qml

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
            text: qsTr("我喜欢的")
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
            onClicked: getFavorite()
        }
        MusicTextButton{
            btnText: "清空记录"
            btnHeight: 50
            btnWidth: 120
            onClicked: clearFavorite()
        }

    }

    MusicListView{
        id:favoriteListView
    }

    Component.onCompleted: {
        getFavorite()
    }

    function getFavorite(){
        favoriteListView.musicList = favoriteSettings.value("favorite",[])
    }

    function clearFavorite(){
        historySettings.setValue("history",[])
        getFavorite()
    }

}
```

### 55 保存我喜欢的歌曲

```qml
//LayoutBottomView.qml

...

//底部工具栏
Rectangle{

    ...

    RowLayout{
        ...

        MusicIconButton{
            Layout.preferredWidth: 50
            icon.source: "qrc:/images/favorite"
            iconWidth: 32
            iconHeight: 32
            toolTip: "我喜欢"
            onClicked: saveFavorite( playList[current])
        }
        ...

    }

    ...

    function saveHistory(index = 0){
        ...
        var item  = playList[index]
        if(!item||!item.id)return
        ...
        if(i>=0) history.splice(i,1)
        ...
    }

    function saveFavorite(value={}){
        if(!value||!value.id)return
        var favorite =  favoriteSettings.value("favorite",[])
        var i =  favorite.findIndex(item=>value.id===item.id)
        if(i>=0) favorite.splice(i,1)
        favorite.unshift({
                            id:value.id+"",
                            name:value.name+"",
                            artist:value.artist+"",
                            url:value.url?value.url:"",
                            type:value.type?value.type:"",
                            album:value.album?value.album:"本地音乐"
                        })
        if(favorite.length>500){
            //限制五百条数据
            favorite.pop()
        }
        favoriteSettings.setValue("favorite",favorite)
    }

    ...

}
```

