## 三 首页菜单

### 12 首页菜单创建

```qml
//PageHomeView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

Frame{

    property var qmlList: [
        {icon:"recommend-white",value:"推荐内容",qml:"DetailRecommendPageView"},
        {icon:"cloud-white",value:"搜索音乐",qml:"DetailSearchPageView"},
        {icon:"local-white",value:"本地音乐",qml:"DetailLocalPageView"},
        {icon:"history-white",value:"播放历史",qml:"DetailHistoryPageView"},
        {icon:"favorite-big-white",value:"我喜欢的",qml:"DetailFavoritePageView"},
        {icon:"favorite-big-white",value:"专辑歌单",qml:"DetailPlayListPageView"}
    ]

    Layout.preferredWidth: 200
    Layout.fillHeight: true
    padding: 0


    ColumnLayout{
        anchors.fill: parent

        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            MusicRoundImage{
                anchors.centerIn:parent
                height: 100
                width:100
                borderRadius: 100
            }
        }

        ListView{
            id:menuView
            height: parent.height
            Layout.fillHeight: true
            Layout.fillWidth: true
            model:ListModel{
                id:menuViewModel
            }
            delegate:menuViewDelegate
        }
    }

    Component{
        id:menuViewDelegate
        Rectangle{
            id:menuViewDelegateItem
            height: 50
            width: 200
            color: "#00AAAA"
            RowLayout{
                anchors.fill: parent
                anchors.centerIn: parent
                spacing:15
                Item{
                    width: 30
                }

                Image{
                    source: "qrc:/images/"+icon
                    Layout.preferredHeight: 20
                    Layout.preferredWidth: 20
                }

                Text{
                    text:value
                    Layout.fillWidth: true
                    height:50
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 12
                    color: "#ffffff"
                }
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    color="#aa73a7ab"
                }
                onExited: {
                    color="#00AAAA"
                }
            }
        }
    }

    Component.onCompleted: {
        menuViewModel.append(qmlList)
    }
}
```

### 13 自定义圆角图片

```qml
//MusicRoundImage.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.0

Item {
    property string imgSrc: "qrc:/images/player"
    property int borderRadius: 5

    Image{
        id:image
        anchors.centerIn: parent
        source:imgSrc
        smooth: true
        visible: false
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectCrop
        antialiasing: true
    }

    Rectangle{
        id:mask
        color: "black"
        anchors.fill: parent
        radius: borderRadius
        visible: false
        smooth: true
        antialiasing: true
    }

    OpacityMask{
        anchors.fill:image
        source: image
        maskSource: mask
        visible: true
        antialiasing: true
    }
}

```



```qml
//PageHomeView.qml

...

Frame{
    ...

    ColumnLayout{
        anchors.fill: parent

        Item{
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            MusicRoundImage{
                anchors.centerIn:parent
                height: 100
                width:100
                borderRadius: 100
            }
        }
        
        ...
    }

    ...
}
```

### 14 菜单鼠标悬停事件

```qml
//PageHomeView.qml

...

Frame{

    ...

    Component{
        id:menuViewDelegate
        Rectangle{
            ...

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    color="#aa73a7ab"
                }
                onExited: {
                    color="#00AAAA"
                }
            }
        }
    }

    ...
}
```

### 15 菜单切换及高亮

```qml
//PageHomeView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12


RowLayout{

    property var qmlList: [
        {icon:"recommend-white",value:"推荐内容",qml:"DetailRecommendPageView"},
        {icon:"cloud-white",value:"搜索音乐",qml:"DetailSearchPageView"},
        {icon:"local-white",value:"本地音乐",qml:"DetailLocalPageView"},
        {icon:"history-white",value:"播放历史",qml:"DetailHistoryPageView"},
        {icon:"favorite-big-white",value:"我喜欢的",qml:"DetailFavoritePageView"}]

    Frame{

        Layout.preferredWidth: 200
        Layout.fillHeight: true
        background: Rectangle{
            color: "#AA00AAAA"
        }
        padding: 0


        ColumnLayout{
            anchors.fill: parent

            ...

            ListView{
                id:menuView
                ...
                
                highlight: Rectangle{
                    color: "#aa73a7ab"
                }
            }
        }

        Component{
            id:menuViewDelegate
            Rectangle{
                id:menuViewDelegateItem
                ...
                
                color: "#AA00AAAA"
                
                ...

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        color="#aa73a7ab"
                    }
                    onExited: {
                        color="#AA00AAAA"
                    }
                    onClicked: {
                        repeater.itemAt(menuViewDelegateItem.ListView.view.currentIndex).visible = false
                        menuViewDelegateItem.ListView.view.currentIndex = index
                        var loader = repeater.itemAt(index)
                        loader.visible = true
                        loader.source = qmlList[index].qml+".qml"
                    }
                }
            }
        }

        Component.onCompleted: {
            menuViewModel.append(qmlList)
            var loader = repeater.itemAt(0)
            loader.visible = true
            loader.source = qmlList[0].qml+".qml"
        }
    }


    Repeater{
        id:repeater
        model:qmlList.length
        Loader{
            visible: false
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
```





