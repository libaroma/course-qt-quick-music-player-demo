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
            color: "#eeffffff"
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
        favoritable: false
        onDeleteItem: deleteFavorite(index)
    }

    Component.onCompleted: {
        getFavorite()
    }

    function getFavorite(){
        favoriteListView.musicList = favoriteSettings.value("favorite",[])
    }

    function clearFavorite(){
        favoriteSettings.setValue("favorite",[])
        getFavorite()
    }

    function deleteFavorite(index){
        var list =favoriteSettings.value("favorite",[])
        if(list.length<index+1)return
        list.splice(index,1)
        favoriteSettings.setValue("favorite",list)
        getFavorite()
    }

}
