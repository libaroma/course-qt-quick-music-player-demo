//DetailRecommendPageView.qml

import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtQml 2.12


ScrollView{
    clip: true
    ColumnLayout {

        Rectangle{

            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("推荐内容")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
                color: "#eeffffff"
            }
        }

        MusicBannerView{
            id:bannerView
            Layout.preferredWidth: window.width-200
            Layout.preferredHeight: (window.width-200)*0.3
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Rectangle{

            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("热门歌单")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
                color: "#eeffffff"
            }
        }

        MusicGridHotView{
            id:hotView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-250)*0.2*4+30*4+20
            Layout.bottomMargin: 20
        }


        Rectangle{

            Layout.fillWidth: true
            width: parent.width
            height: 60
            color: "#00000000"
            Text {
                x:10
                verticalAlignment: Text.AlignBottom
                text: qsTr("新歌推荐")
                font.family: window.mFONT_FAMILY
                font.pointSize: 25
                color: "#eeffffff"
            }
        }


        MusicGridLatestView{
            id:latestView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: (window.width-230)*0.1*10+20
            Layout.bottomMargin: 20
        }

    }

    Component.onCompleted: {
        getBannerList()
    }

    function getBannerList(){

        loading.open()
        function onReply(reply){
            loading.close()
            http.onReplySignal.disconnect(onReply)
            try{
                if(reply.length<1){
                    notification.openError("请求轮播图为空！")
                    return
                }
                var banners = JSON.parse(reply).banners
                bannerView.bannerList = banners
                getHotList()

            }catch(err){
                notification.openError("请求轮播图出错！")
            }
        }

        http.onReplySignal.connect(onReply)
        http.connet("banner")
    }

    function getHotList(){

        loading.open()
        function onReply(reply){
            loading.close()
            http.onReplySignal.disconnect(onReply)

            try{
                if(reply.length<1){
                    notification.openError("请求热门推荐为空！")
                    return
                }
                var playlists = JSON.parse(reply).playlists
                hotView.list =playlists
                getLatestList()
            }catch(err){
                notification.openError("请求热门推荐出错！")
            }
        }

        http.onReplySignal.connect(onReply)
        http.connet("top/playlist/highquality?limit=20")
    }
    function getLatestList(){
        loading.open()
        function onReply(reply){
            loading.close()
            try{
                if(reply.length<1){
                    notification.openError("请求最新歌曲为空！")
                    return
                }
                http.onReplySignal.disconnect(onReply)
                var latestList = JSON.parse(reply).data
                latestView.list =latestList.slice(0,30)
            }catch(err){
                notification.openError("请求最新歌曲出错！")
            }
        }

        http.onReplySignal.connect(onReply)
        http.connet("top/song")
    }
}



