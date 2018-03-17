import QtQuick 2.0
import Sailfish.Silica 1.0


Column {
    property alias title: titleLabel.text
    property int appsCount: 0
    property int configSize: 0
    property int cacheSize: 0
    property int localDataSize: 0

    opacity: appsCount > 0 ? 1.0 : 0.0
    visible: opacity === 1.0
    width: parent.width

    Behavior on opacity { FadeAnimation { } }

    Label {
        id: titleLabel
        width: parent.width
        horizontalAlignment: Qt.AlignHCenter
        font.pixelSize: Theme.fontSizeLarge
        color: Theme.highlightColor
        wrapMode: Text.WordWrap
    }

    DetailItem {
        rightMargin: 0.0
        leftMargin: 0.0
        //% "Applications"
        label: qsTrId("hsy-apps")
        value: appsCount
    }

    DetailItem {
        rightMargin: 0.0
        leftMargin: 0.0
        visible: shipyard.processConfigEnabled && configSize > 0
        label: qsTrId("hsy-config")
        value: prettyBytes(configSize)
    }

    DetailItem {
        rightMargin: 0.0
        leftMargin: 0.0
        visible: cacheSize > 0
        label: qsTrId("hsy-cache")
        value: prettyBytes(cacheSize)
    }

    DetailItem {
        rightMargin: 0.0
        leftMargin: 0.0
        visible: localDataSize > 0
        label: qsTrId("hsy-localdata")
        value: prettyBytes(localDataSize)
    }

    DetailItem {
        rightMargin: 0.0
        leftMargin: 0.0
        visible: ((configSize    > 0) * 1 +
                  (cacheSize     > 0) * 1 +
                  (localDataSize > 0) * 1) > 1
        //% "Total"
        label: qsTrId("hsy-total")
        value: prettyBytes(configSize + cacheSize + localDataSize)
    }
}
