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

    MusicToolTip{
        visible: parent.hovered
        text: toolTip
    }

    background: Rectangle{
        color: self.down||(isCheckable&&self.checked)?"#eeeeee":"#00000000"
    }
    icon.color: self.down||(isCheckable&&self.checked)?"#00000000":"#eeeeee"

    checkable: isCheckable
    checked: isChecked
}




