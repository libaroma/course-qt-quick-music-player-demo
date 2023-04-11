## 二 窗体布局

### 03 顶部工具栏 

```qml
//App.qml

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ApplicationWindow {

    width: 1200
    height: 800
    visible: true
    title: qsTr("Demo Cloud Music Player")

    ToolBar{
        background: Rectangle{
            color: "#00AAAA"
        }

        width: parent.width
        Layout.fillWidth: true
        RowLayout{
            anchors.fill: parent

            ToolButton{
                icon.source: "qrc:/images/music"
                toolTip: "关于"
            }
            ToolButton{
                icon.source: "qrc:/images/about"
                toolTip: "续加仪的博客"
            }
            ToolButton{
                id:smallWindow
                iconSource: "qrc:/images/small-window"
                toolTip: "小窗播放"
            }
            ToolButton{
                id:normalWindow
                iconSource: "qrc:/images/exit-small-window"
                toolTip: "退出小窗播放"
                visible: false
            }
            Item{
                Layout.fillWidth: true
                height: 32
                Text {
                    anchors.centerIn: parent
                    text: qsTr("续加仪")
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 15
                    color:"#ffffff"
                }
            }
            ToolButton{
                icon.source: "qrc:/images/minimize-screen"
                toolTip: "最小化"
            }
            ToolButton{
                id:resize
                icon.source: "qrc:/images/small-screen"
                toolTip: "退出全屏"
                visible: false
            }
            ToolButton{
                id:maxWindow
                icon.source: "qrc:/images/full-screen"
                toolTip: "全屏"
            }
            ToolButton{
                icon.source: "qrc:/images/power"
                toolTip: "退出"
            }
        }
    }
}
```

### 04 窗体布局区域划分

```qml
//App.qml

...

ApplicationWindow {

    ...

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        ToolBar{
            ...
        }
        
        Frame{
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            background: Rectangle{
                color: "#f0f0f0"
            }
            padding: 0
        }
        
        //底部工具栏
        Rectangle{
            Layout.fillWidth: true
            height: 60
            color: "#00AAAA"
        }
    }
}
```

### 05 底部工具栏

```qml
//App.qml

...

ApplicationWindow {

    ...

    ColumnLayout{
        ...
        
        
        //底部工具栏
        Rectangle{
            Layout.fillWidth: true
            height: 60
            color: "#00AAAA"

            RowLayout{
                anchors.fill: parent

                Item{
                    Layout.preferredWidth: parent.width/10
                    Layout.fillWidth: true
                }
                Button{
                    icon.source: "qrc:/images/previous"
                    iconWidth: 32
                    iconHeight: 32
                    toolTip: "上一曲"
                }
                Button{
                    iconSource: "qrc:/images/stop"
                    iconWidth: 32
                    iconHeight: 32
                    toolTip: "暂停/播放"
                }
                Button{
                    icon.source: "qrc:/images/next"
                    iconWidth: 32
                    iconHeight: 32
                    toolTip: "下一曲"
                }
                Item{
                    Layout.preferredWidth: parent.width/2
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.topMargin: 25

                    Text{
                        id:nameText
                        anchors.left:slider.left
                        anchors.bottom: slider.top
                        anchors.leftMargin: 5
                        text:"续加仪-续加仪"
                        font.family: "微软雅黑"
                        color: "#ffffff"
                    }
                    Text{
                        id:timeText
                        anchors.right: slider.right
                        anchors.bottom: slider.top
                        anchors.rightMargin: 5
                        text:"00:00/05:30"
                        font.family: "微软雅黑"
                        color: "#ffffff"
                    }

                    Slider{
                        id:slider
                        width: parent.width
                        Layout.fillWidth: true
                        height: 25
                    }
                }

                Button{
                    Layout.preferredWidth: 50
                    icon.source: "qrc:/images/favorite"
                    iconWidth: 32
                    iconHeight: 32
                    toolTip: "我喜欢"
                }
                Button{
                    Layout.preferredWidth: 50
                    icon.source: "qrc:/images/repeat"
                    iconWidth: 32
                    iconHeight: 32
                    toolTip: "重复播放"
                }
                Item{
                    Layout.preferredWidth: parent.width/10
                    Layout.fillWidth: true
                }
            }
        }
    }
}
```

### 06 美化进度条

```qml
//App.qml

...

ApplicationWindow {
    ...

    ColumnLayout{
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
                        width: parent.width
                        Layout.fillWidth: true
                        height: 25
                        background:Rectangle{
                            x:slider.leftPadding
                            y:slider.topPadding+(slider.availableHeight-height)/2
                            width: slider.availableWidth
                            height: 4
                            radius: 2
                            color: "#e9f4ff"
                            Rectangle{
                                width: slider.visualPosition*parent.width
                                height: parent.height
                                color: "#73a7ab"
                                radius: 2
                            }
                        }
                        handle:Rectangle{
                            x:slider.leftPadding+(slider.availableWidth-width)*slider.visualPosition
                            y:slider.topPadding+(slider.availableHeight-height)/2
                            width: 15
                            height: 15
                            radius: 5
                            color: "#f0f0f0"
                            border.color: "#73a7ab"
                            border.width: 0.5
                        }
                    }
                }
                ...
            }
        }
    }
}
```

### 07 组件化布局

```qml
//App.qml

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ApplicationWindow {

    width: 1200
    height: 800
    visible: true
    title: qsTr("Demo Cloud Music Player")

    ColumnLayout{
        anchors.fill: parent
        spacing: 0

        LayoutHeaderView{
            id:layoutHeaderView
        }

        PageHomeView{
            id:pageHomeView
        }

        LayoutBottomView{
            id:layoutBottomView
        }
    }

}
```

### 08 自定义Button

```qml
//MusicIconButton.qml

import QtQuick 2.12
import QtQuick.Controls 2.5

Button{
    property string iconSource: ""

    property string toolTip: ""

    property bool isCheckable:false
    property bool isChecked:false

    property int iconWidth: 32
    property int iconHeight: 32

    id:self

    icon.source:iconSource
    icon.height: iconHeight
    icon.width: iconWidth

    ToolTip.visible: hovered
    ToolTip.text: toolTip

    background: Rectangle{
        color: self.down||(isCheckable&&self.checked)?"#497563":"#20e9f4ff"
        radius: 3
    }
    icon.color: self.down||(isCheckable&&self.checked)?"#ffffff":"#e2f0f8"

    checkable: isCheckable
    checked: isChecked
}

```

### 09 自定义ToolButton

```qml
//MusicToolButton.qml

import QtQuick 2.12
import QtQuick.Controls 2.5

ToolButton{
    property string iconSource: ""
    property string toolTip: ""

    property bool isCheckable:false
    property bool isChecked:false

    id:self

    icon.source:iconSource

    ToolTip.visible: hovered
    ToolTip.text: toolTip

    background: Rectangle{
        color: self.down||(isCheckable&&self.checked)?"#eeeeee":"#00000000"
    }
    icon.color: self.down||(isCheckable&&self.checked)?"#00000000":"#eeeeee"

    checkable: isCheckable
    checked: isChecked
}

```

### 10 顶部工具功能实现

```qml
//LayoutHeaderView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12


ToolBar{
    background: Rectangle{
        color: "#00AAAA"
    }

    width: parent.width
    Layout.fillWidth: true
    RowLayout{
        anchors.fill: parent

        MusicToolButton{
            icon.source: "qrc:/images/music"
            toolTip: "关于"
        }
        MusicToolButton{
            icon.source: "qrc:/images/about"
            toolTip: "续加仪的博客"
            onClicked: {
                Qt.openUrlExternally("https://www.hyz.cool")
            }
        }
        MusicToolButton{
            id:smallWindow
            iconSource: "qrc:/images/small-window"
            toolTip: "小窗播放"
            onClicked: {
                setWindowSize(330,650)
                smallWindow.visible=false
                normalWindow.visible=true
            }
        }
        MusicToolButton{
            id:normalWindow
            iconSource: "qrc:/images/exit-small-window"
            toolTip: "退出小窗播放"
            visible: false
            onClicked: {
                setWindowSize()
                normalWindow.visible=false
                smallWindow.visible=true
            }
        }
        Item{
            Layout.fillWidth: true
            height: 32
            Text {
                anchors.centerIn: parent
                text: qsTr("续加仪")
                font.family: window.mFONT_FAMILY
                font.pointSize: 15
                color:"#ffffff"
            }
        }
        MusicToolButton{
            icon.source: "qrc:/images/minimize-screen"
            toolTip: "最小化"
            onClicked: {
                window.hide()
            }
        }
        MusicToolButton{
            id:resize
            icon.source: "qrc:/images/small-screen"
            toolTip: "退出全屏"
            visible: false
            onClicked: {
                setWindowSize()
                window.visibility = Window.AutomaticVisibility
                maxWindow.visible = true
                resize.visible = false
            }
        }
        MusicToolButton{
            id:maxWindow
            icon.source: "qrc:/images/full-screen"
            toolTip: "全屏"
            onClicked: {
                window.visibility = Window.Maximized
                maxWindow.visible = false
                resize.visible = true
            }
        }
        MusicToolButton{
            icon.source: "qrc:/images/power"
            toolTip: "退出"
            onClicked: {
                Qt.quit()
            }
        }
    }

    function setWindowSize(width = window.mWINDOW_WIDTH,height = window.mWINDOW_HEIGHT){
        window.width = width
        window.height = height
        window.x=(Screen.desktopAvailableWidth-window.width)/2
        window.y=(Screen.desktopAvailableHeight-window.height)/2
    }
}


```

### 11 自定义弹窗关于

```qml
//LayoutHeaderView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12

ToolBar{
    ...
    RowLayout{
        anchors.fill: parent

        MusicToolButton{
            icon.source: "qrc:/images/music"
            toolTip: "关于"
            onClicked: {
                aboutPop.open()
            }
        }
        ...
    }

    Popup{
        id:aboutPop

        topInset: 0
        leftInset: -2
        rightInset: 0
        bottomInset: 0

        parent: Overlay.overlay
        x:(parent.width-width)/2
        y:(parent.height-height)/2

        width: 250
        height: 230

        background: Rectangle{
            color:"#e9f4ff"
            radius: 5
            border.color: "#2273a7ab"
        }

        contentItem: ColumnLayout{
            width: parent.width
            height: parent.height
            Layout.alignment: Qt.AlignHCenter

            Image{
                Layout.preferredHeight: 60
                source: "qrc:/images/music"
                Layout.fillWidth:true
                fillMode: Image.PreserveAspectFit

            }

            Text {
                text: qsTr("续加仪")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 18
                color: "#8573a7ab"
                font.family: window.mFONT_FAMILY
                font.bold: true
            }
            Text {
                text: qsTr("这是我的Cloud Music Player")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
                color: "#8573a7ab"
                font.family:  window.mFONT_FAMILY
                font.bold: true
            }
            Text {
                text: qsTr("www.hyz.cool")
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 16
                color: "#8573a7ab"
                font.family:  window.mFONT_FAMILY
                font.bold: true
            }
        }
    }
    ...
}
```

