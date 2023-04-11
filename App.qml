//App.qml

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

ApplicationWindow {

    id:window

    property int mWINDOW_WIDTH: 1200
    property int mWINDOW_HEIGHT: 800

    property string mFONT_FAMILY: "微软雅黑"


    width: mWINDOW_WIDTH
    height: mWINDOW_HEIGHT
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
