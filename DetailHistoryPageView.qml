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
        onDeleteItem: deleteHistory(index)
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


    function deleteHistory(index){
        var list =historySettings.value("history",[])
        if(list.length<index+1)return
        list.splice(index,1)
        historySettings.setValue("history",list)
        getHistory()
    }

}
