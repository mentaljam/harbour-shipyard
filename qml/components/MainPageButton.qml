import QtQuick 2.0
import Sailfish.Silica 1.0


BackgroundItem {
    property alias iconSource: icon.source
    property alias text: label.text

    width: Screen.width / 2
    height: width

    Image {
        id: icon
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: Theme.paddingLarge * 2
        }
        width: parent.width * 0.4
        height: width
        smooth: true
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: label
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }
        color: pressed ? Theme.highlightColor : Theme.primaryColor
        horizontalAlignment: Qt.AlignHCenter
        wrapMode: Text.WordWrap
        maximumLineCount: 2
    }
}
