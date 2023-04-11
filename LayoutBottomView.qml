//LayoutBottomView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

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
        MusicIconButton{
            icon.source: "qrc:/images/previous"
            iconWidth: 32
            iconHeight: 32
            toolTip: "上一曲"
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

        MusicIconButton{
            Layout.preferredWidth: 50
            icon.source: "qrc:/images/favorite"
            iconWidth: 32
            iconHeight: 32
            toolTip: "我喜欢"
        }
        MusicIconButton{
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

