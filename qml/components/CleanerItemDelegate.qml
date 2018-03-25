import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.shipyard 1.0


ListItem {
    id: delegate
    width: parent.width
    contentHeight: content.height + Theme.paddingMedium * 2

    menu: ContextMenu {
        x: 0

        MenuItem {
            id: deleteAllItem
            visible: deleteConfigItem.visible +
                     deleteCacheItem.visible +
                     deleteLocalDataItem.visible > 1
            //% "Delete all data"
            text: qsTrId("hsy-delete-all")
            //% "Deleting all data"
            onClicked: remorseAction(qsTrId("hsy-deleting-alldata"), function() {
                appListModel.deleteData(name, shipyard.processConfigEnabled ?
                                     AppListModel.AllData :
                                     AppListModel.CacheData | AppListModel.LocalData)
            })
        }

        MenuItem {
            id: deleteConfigItem
            visible: shipyard.processConfigEnabled &&
                     (!installed || shipyard.deleteAllDataAllowed) && configSize > 0
            //% "Delete configuration"
            text: qsTrId("hsy-delete-config")
            //% "Deleting configuration"
            onClicked: remorseAction(qsTrId("hsy-deleting-config"), function() {
                appListModel.deleteData(name, AppListModel.ConfigData)
            })
        }

        MenuItem {
            id: deleteCacheItem
            visible: cacheSize > 0
            //% "Delete cache"
            text: qsTrId("hsy-delete-cache")
            //% "Deleting cache"
            onClicked: remorseAction(qsTrId("hsy-deleting-cache"), function() {
                appListModel.deleteData(name, AppListModel.CacheData)
            })
        }

        MenuItem {
            id: deleteLocalDataItem
            visible: (!installed || shipyard.deleteAllDataAllowed) && localDataSize > 0
            //% "Delete local data"
            text: qsTrId("hsy-delete-localdata")
            //% "Deleting local data"
            onClicked: remorseAction(qsTrId("hsy-deleting-localdata"), function() {
                appListModel.deleteData(name, AppListModel.LocalData)
            })
        }
    }

    ListView.onRemove: RemoveAnimation {
        target: delegate
    }

    Image {
        id: iconItem
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
        }
        width: Theme.iconSizeLauncher
        height: width
        visible: icon
        source: icon
    }

    Column {
        id: content
        anchors {
            verticalCenter: parent.verticalCenter
            left: iconItem.visible ? iconItem.right : parent.left
            leftMargin: Theme.horizontalPageMargin
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
        }

        Label {
            width: parent.width
            wrapMode: Text.WordWrap
            text: title
            color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
        }

        CleanerSizeLabel {
            visible: shipyard.processConfigEnabled
            //% "Configuration"
            label: qsTrId("hsy-config")
            value: configSize
        }

        CleanerSizeLabel {
            //% "Cache"
            label: qsTrId("hsy-cache")
            value: cacheSize
        }

        CleanerSizeLabel {
            //% "Local data"
            label: qsTrId("hsy-localdata")
            value: localDataSize
        }
    }
}
