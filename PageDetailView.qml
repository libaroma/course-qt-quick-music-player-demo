//PageDetailView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQml 2.12

Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    property alias lyrics : lyricView.lyrics
    property alias current : lyricView.current

    RowLayout{
        anchors.fill: parent
        Frame{
            Layout.preferredWidth: parent.width*0.45
            Layout.fillWidth: true
            Layout.fillHeight: true

            background: Rectangle{
                color: "#00000000"
            }

            Text {
                id: name
                text: layoutBottomView.musicName
                anchors{
                    bottom: artist.top
                    bottomMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 16
                }
                color: "#eeffffff"
            }

            Text {
                id: artist
                text: layoutBottomView.musicArtist
                anchors{
                    bottom: cover.top
                    bottomMargin: 50
                    topMargin: 20
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }
                color: "#aaffffff"
            }
            MusicBorderImage{
                id:cover
                anchors.centerIn: parent
                width: parent.width*0.6
                height: width
                borderRadius: width
                imgSrc: layoutBottomView.musicCover
                isRotating:  layoutBottomView.playingState===1
            }

            Text {
                id: lyric
                visible: layoutHeaderView.isSmallWindow
                text: lyricView.lyrics[lyricView.current]?lyricView.lyrics[lyricView.current]:"暂无歌词"
                anchors{
                    top: cover.bottom
                    topMargin: 50
                    horizontalCenter: parent.horizontalCenter
                }
                font{
                    family: window.mFONT_FAMILY
                    pointSize: 12
                }
                color: "#aaffffff"
            }

            MouseArea{
                id:mouseArea
                anchors.fill: parent
                hoverEnabled: true

                onEntered: displayHeaderAndBottom(false)
                onExited: displayHeaderAndBottom(true)
                onMouseXChanged: {
                    timer.stop()
                    cursorShape = Qt.ArrowCursor
                    timer.start()
                }
                onClicked: {
                    displayHeaderAndBottom(true)
                    timer.stop()
                }
            }
        }

        Frame{
            visible: !layoutHeaderView.isSmallWindow
            Layout.preferredWidth: parent.width*0.55
            Layout.fillHeight: true
            background: Rectangle{
                color: "#0000AAAA"
            }

            MusicLyricView{
                id:lyricView
                anchors.fill: parent
            }

        }

    }

    Timer{
        id:timer
        interval: 3000
        onTriggered: {
            mouseArea.cursorShape = Qt.BlankCursor
            displayHeaderAndBottom(false)
        }
    }

    function displayHeaderAndBottom(visible = true){
        layoutHeaderView.visible = pageHomeView.visible||visible
        layoutBottomView.visible = pageHomeView.visible||visible
    }


}
