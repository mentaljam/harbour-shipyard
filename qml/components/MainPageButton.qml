import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0


BackgroundItem {
    property alias iconSource: icon.source
    property alias text: label.text
    readonly property color _color: highlighted ? Theme.highlightColor : Theme.primaryColor

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

    ColorOverlay {
        anchors.fill: icon
        source: icon
        color: _color
    }

    Text {
        id: label
        anchors {
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }
        color: _color
        horizontalAlignment: Qt.AlignHCenter
        wrapMode: Text.WordWrap
        maximumLineCount: 2
    }
}
