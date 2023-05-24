//MusicGridLatestView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQml 2.12

Item{

    property alias list: gridRepeater.model

    Grid{
        id:gridLayout
        anchors.fill:parent
        columns: 3
        Repeater{
            id:gridRepeater
            Frame{
                padding: 5
                width: parent.width*0.333
                height: parent.width*0.1
                background: Rectangle{
                    id:background
                    color: "#00000000"
                }

                clip: true

                MusicBorderImage{
                    id:img
                    width: parent.width*0.25
                    height: parent.width*0.25
                    imgSrc: modelData.album.picUrl
                }

                Text{
                    id:name
                    anchors{
                        left: img.right
                        verticalCenter: parent.verticalCenter
                        bottomMargin: 10
                        leftMargin: 5
                    }
                    text:modelData.album.name
                    font.family: window.mFONT_FAMILY
                    font.pointSize: 11
                    height:30
                    width: parent.width*0.72
                    elide: Qt.ElideRight
                    color: "#eeffffff"
                }
                Text{
                    anchors{
                        left: img.right
                        top: name.bottom
                        leftMargin: 5
                    }
                    text:modelData.artists[0].name
                    font.family: window.mFONT_FAMILY
                    height:30
                    width: parent.width*0.72
                    elide: Qt.ElideRight
                    color: "#eeffffff"
                }


                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        background.color = "#50ffffff"
                    }
                    onExited: {
                        background.color = "#00000000"
                    }
                    onClicked: {
                        layoutBottomView.current = -1
                        layoutBottomView.playList = [{
                                                         id:list[index].id,
                                                         name:list[index].name,
                                                         artist:list[index].artists[0].name,
                                                         album:list[index].album.name,
                                                         cover:list[index].album.picUrl,
                                                         type:"0"
                                                     }]
                        layoutBottomView.current = 0
                    }
                }
            }
        }
    }
}
