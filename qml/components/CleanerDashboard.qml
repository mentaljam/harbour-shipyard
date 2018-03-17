import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.shipyard 1.0


SilicaFlickable {
    opacity: !cleanerModel.resetting ? 1.0 : 0.0
    visible: opacity === 1.0
    contentHeight: header.height + content.height

    Behavior on opacity { FadeAnimation { } }

    CleanerPageMenu { }

    VerticalScrollDecorator { }

    PageHeader {
        id: header
        visible: isPortrait
        height: visible ? _preferredHeight : Theme.paddingLarge
        //% "Cleaning"
        title: qsTrId("hsy-cleaning")
    }

    Column {
        id: content
        anchors {
            top: header.bottom
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }
        width: parent.width
        spacing: Theme.paddingMedium

        CleanerDataLabel {
            //% "Found"
            title: qsTrId("hsy-found")
            appsCount: cleanerModel.totalAppsCount
            configSize: cleanerModel.totalConfigSize
            cacheSize: cleanerModel.totalCacheSize
            localDataSize: cleanerModel.totalLocaldataSize
        }

        CleanerDataLabel {
            opacity: _canDeleteUnused ? 1.0 : 0.0
            //% "Unused"
            title: qsTrId("hsy-unused")
            appsCount: cleanerModel.unusedAppsCount
            configSize: cleanerModel.unusedConfigSize
            cacheSize: cleanerModel.unusedCacheSize
            localDataSize: cleanerModel.unusedLocaldataSize
        }

        Item {
            opacity: shipyard.totalDeletedData > 0 ? 1.0 : 0.0
            visible: opacity === 1.0
            width: parent.width
            height: deletedLabel.height + deletedDetailItem.height

            Behavior on opacity { FadeAnimation { } }

            Label {
                id: deletedLabel
                width: parent.width
                horizontalAlignment: Qt.AlignHCenter
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
                wrapMode: Text.WordWrap
                //% "Deleted"
                text: qsTrId("hsy-total-deleted")
            }

            DetailItem {
                id: deletedDetailItem
                anchors.top: deletedLabel.bottom
                label: qsTrId("hsy-total")
                value: prettyBytes(shipyard.totalDeletedData)
            }
        }
    }
}
