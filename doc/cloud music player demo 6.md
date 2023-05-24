## 六 搜索音乐

### 25 搜索音乐页面布局

- DetailSearchPageView.qml

```qml
//DetailSearchPageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12


ColumnLayout{
    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle{

        Layout.fillWidth: true
        width: parent.width
        height: 60
        color: "#00000000"
        Text {
            x:10
            verticalAlignment: Text.AlignBottom
            text: qsTr("搜索音乐")
            font.family: window.mFONT_FAMILY
            font.pointSize: 25
        }
    }

    RowLayout{

        Layout.fillWidth: true

        TextField{
            id:searchInput
            font.family: window.mFONT_FAMILY
            font.pointSize: 14
            selectByMouse: true
            selectionColor: "#999999"
            placeholderText: qsTr("请输入搜索关键词")
            color: "#000000"
            background: Rectangle{
                border.width: 1
                border.color: "black"
                opacity: 0.5
                implicitHeight: 40
                implicitWidth: 400
            }
            focus: true
        }


        MusicIconButton{
            iconSource: "qrc:/images/search"
            toolTip: "搜索"
        }

    }

    Frame{
        id:musicListView
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

}
```

### 26 音乐列表MusicListView

```qml
//DetailSearchPageView.qml

...

ColumnLayout{
    ...

    MusicListView{
        id:musicListView
    }

}

```

- MusicListView.qml

```qml
//MusicListView.qml

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.5
import QtQml 2.12

Frame{

    Layout.fillHeight: true
    Layout.fillWidth: true

    clip: true
    padding: 0

    background: Rectangle{
        color: "#00000000"
    }

    ListView{
        id:listView
        anchors.fill: parent
        model:ListModel{
            id:listViewModel
        }
        delegate: listViewDelegate
        ScrollBar.vertical: ScrollBar{
            anchors.right: parent.right
        }
        header: listViewHeader
    }

    Component{
        id:listViewDelegate
        Rectangle{
            height: 45
            width: listView.width
            RowLayout{
                width: parent.width
                height: parent.height
                spacing: 15
                x:5
                Text{
                    text:index+1
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.05
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text:name
                    Layout.preferredWidth: parent.width*0.4
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text:artist
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text:album
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"操作"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
            }
        }
    }

    Component{
        id:listViewHeader
        Rectangle{
            color: "#aaa"
            height: 45
            width: listView.width
            RowLayout{
                width: parent.width
                height: parent.height
                spacing: 15
                x:5
                Text{
                    text:"序号"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.05
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"歌名"
                    Layout.preferredWidth: parent.width*0.4
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"歌手"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"专辑"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
                Text{
                    text:"操作"
                    horizontalAlignment: Qt.AlignHCenter
                    Layout.preferredWidth: parent.width*0.15
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 13
                    color: "black"
                    elide: Qt.ElideRight
                }
            }
        }
    }
}
```

### 27 音乐搜索列表展示

- DetailSearchPageView.qml

```qml
//DetailSearchPageView.qml

...

ColumnLayout{
    ...

    RowLayout{

        ...
        
        TextField{
            ...
            
            Keys.onPressed: if(event.key===Qt.Key_Enter||event.key===Qt.Key_Return)doSearch()
        }

        MusicIconButton{
            iconSource: "qrc:/images/search"
            toolTip: "搜索"
            onClicked: doSearch()
        }

    }

    MusicListView{
        id:musicListView
    }

    function doSearch(){
        var keywords = searchInput.text
        if(keywords.length<1)return
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            console.log(reply)
            var songsList = JSON.parse(reply).result.songs
            musicListView.musicList = songsList.map(item=>{
                                                     return {
                                                            id:item.id,
                                                            name:item.name,
                                                            artist:item.artists[0].name,
                                                            album:item.album.name
                                                        }
                                                    })
        }
        http.onReplySignal.connect(onReply)
        http.connet("search?keywords="+keywords)
    }
}
```

- MusicListView.qml

```qml
//MusicListView.qml

...

Frame{

    property var musicList: []

    onMusicListChanged: {
        listViewModel.clear()
        listViewModel.append(musicList)
    }

    ...
}
```

### 28 音乐搜索列表分页

```qml
//DetailSearchPageView.qml

...

ColumnLayout{
    ...

    MusicListView{
        id:musicListView
        onLoadMore:doSearch(offset)
    }

    function doSearch(offset = 0){
        var keywords = searchInput.text
        if(keywords.length<1)return
        function onReply(reply){
            http.onReplySignal.disconnect(onReply)
            var result = JSON.parse(reply).result
            musicListView.all = result.songCount
            musicListView.musicList = result.songs.map(item=>{
                                                     return {
                                                            id:item.id,
                                                            name:item.name,
                                                            artist:item.artists[0].name,
                                                            album:item.album.name
                                                        }
                                                    })

        }
        http.onReplySignal.connect(onReply)
        http.connet("search?keywords="+keywords+"&offset="+offset+"&limit=60")
    }
}

```

- MusicListView.qml

```qml
//MusicListView.qml

...

Frame{

    ...
    property int all: 0
    property int pageSize: 60
    property int current: 0

    signal loadMore(int offset)


    ...

    ListView{
        id:listView
        anchors.fill: parent
        anchors.bottomMargin: 60
        ...
    }

    Component{
        id:listViewDelegate
        Rectangle{
            ...
            RowLayout{
                ...
                Text{
                    text:index+1+pageSize*current
                    ...
                }
                ...
            }
        }
    }

    ...

    Item{
        id:pageButton
        visible: musicList.length!==0
        width: parent.width
        height: 40
        anchors.top: listView.bottom
        anchors.topMargin: 20

        ButtonGroup{
            buttons:buttons.children
        }
        RowLayout{
            id:buttons
            anchors.centerIn: parent
            Repeater{
                id:repeater
                model: all/pageSize>9?9:all/pageSize
                Button{
                    Text{
                        anchors.centerIn: parent
                        text: modelData+1
                        font.family: window.mFONT_FAMILY
                        font.pointSize: 14
                        color: checked?"#497563":"balck"
                    }
                    background: Rectangle{
                        implicitHeight: 30
                        implicitWidth: 30
                        color: checked?"#e2f0f8":"#20e9f4ff"
                        radius: 3
                    }
                    checkable: true
                    checked: modelData === current
                    onClicked: {
                        if(current===index) return
                        current = index
                        loadMore(current*pageSize)
                    }
                }
            }
        }
    }
}
```

### 29 音乐列表操作按钮

```qml
//MusicListView.qml

...

Frame{

    ...

    Component{
        id:listViewDelegate
        Rectangle{
            ...

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
                                //播放
                            }
                        }
                        MusicIconButton{
                            iconSource: "qrc:/images/favorite"
                            iconHeight: 16
                            iconWidth: 16
                            toolTip: "喜欢"
                            onClicked: {
                                //喜欢
                            }
                        }
                        MusicIconButton{
                            iconSource: "qrc:/images/clear"
                            iconHeight: 16
                            iconWidth: 16
                            toolTip: "删除"
                            onClicked: {
                                //删除
                            }
                        }
                    }
                }
            }
        }
    }
}
```

### 30 音乐列表行高亮

```qml
//MusicListView.qml

...

Frame{

    ...

    ListView{
        ...
        highlight:Rectangle{
            color: "#f0f0f0"
        }
        highlightMoveDuration: 0
        highlightResizeDuration: 0
    }

    Component{
        id:listViewDelegate
        Rectangle{
            id:listViewDelegateItem
            height: 45
            width: listView.width

            MouseArea{
                RowLayout{
                    ...
            	}

                anchors.fill:parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: {
                    color = "#f0f0f0"
                }
                onExited: {
                    color = "#00000000"
                }
                onClicked: {
                    listViewDelegateItem.ListView.view.currentIndex = index
                }

            }
        }
    }
    ...
    
}
```

### 31 音乐列表底边框

```qml
//MusicListView.qml

...
import QtQuick.Shapes 1.12


Frame{

    ...

    Component{
        id:listViewDelegate
        Rectangle{
            id:listViewDelegateItem
            height: 45
            width: listView.width

            Shape{
                anchors.fill: parent
                ShapePath{
                    strokeWidth: 0
                    strokeColor: "#50000000"
                    strokeStyle: ShapePath.SolidLine
                    startX: 0
                    startY: 45
                    PathLine{
                        x:0
                        y:45
                    }
                    PathLine{
                        x:parent.width
                        y:45
                    }
                }
            }
        }
    }

   ...
}
```

### 32 搜索页面逻辑修复

```qml
//DetailSearchPageView.qml

...

ColumnLayout{
    ...

    MusicListView{
        id:musicListView
        onLoadMore:doSearch(offset,current)
        Layout.topMargin: 10
    }

    function doSearch(offset = 0,current = 0){
        ...
        function onReply(reply){
            ...
            musicListView.current = current
            ...
        }
        ...
    }
}
```

```qml
//MusicListView.qml

...

Frame{

    ...

    signal loadMore(int offset,int current)


    ...

    ListView{
        ...
        anchors.bottomMargin: 70
        ...
    }

    Component{
        id:listViewDelegate
        Rectangle{
            ...

            MouseArea{
                RowLayout{
                    ...
                    Text{
                        ...
                        elide: Qt.ElideMiddle
                    }
                    Text{
                        ...
                        elide: Qt.ElideMiddle
                    }
                ...

            }
        }
    }

    Component{
        id:listViewHeader
        Rectangle{
            color: "#00AAAA"
            height: 45
            width: listView.width
            RowLayout{
                ...
                Text{
                    text:"歌手"
                    ...
                    elide: Qt.ElideMiddle
                }
                Text{
                    text:"专辑"
                    ...
                    elide: Qt.ElideMiddle
                }
                Text{
                    text:"操作"
                    ...
                    elide: Qt.ElideRight
                }
            }
        }
    }

    Item{
        id:pageButton
        ...
        RowLayout{
            id:buttons
            anchors.centerIn: parent
            Repeater{
                id:repeater
                model: all/pageSize>9?9:all/pageSize
                Button{
                    ...
                    onClicked: {
                        if(current===index) return
                        loadMore(current*pageSize,index)
                    }
                }
            }
        }
    }
}
```

