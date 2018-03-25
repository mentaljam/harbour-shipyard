import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Notifications 1.0
import harbour.shipyard 1.0
import "pages"


ApplicationWindow {
    readonly property var _locale: Qt.locale()
    readonly property bool _canDeleteUnused:
        !appListModel.busy && (shipyard.processConfigEnabled ?
                                   appListModel.unusedAppsCount > 0 :
                                   appListModel.unusedCacheSize + appListModel.unusedLocaldataSize > 0)

    function prettyBytes(bytes) {
        var i = 0
        while (bytes > 1024 && i < 4) {
            bytes /= 1024
            i += 1
        }

        switch (i) {
        case 0:
            //% "%n byte(s)"
            return qsTrId("hsy-bytes", bytes)
        case 1:
            //% "%1 KB"
            return qsTrId("hsy-kb").arg(Number(bytes).toLocaleString(_locale, 'f', 0))
        case 2:
            //% "%1 MB"
            return qsTrId("hsy-mb").arg(Number(bytes).toLocaleString(_locale, 'f', 0))
        case 3:
            //% "%1 GB"
            return qsTrId("hsy-gb").arg(Number(bytes).toLocaleString(_locale, 'f', 1))
        default:
            return ""
        }
    }

    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    _defaultPageOrientations: Orientation.All

    Notification {

        function show(text, icn) {
            replacesId = 0
            previewSummary = ""
            previewBody = text
            icon = icn ? icn : ""
            publish()
        }

        function showPopup(title, text, icn) {
            replacesId = 0
            previewSummary = title
            previewBody = text
            icon = icn
            publish()
        }

        id: notification
        expireTimeout: 3000
    }

    Shipyard {
        id: shipyard
    }

    AppListModel {
        id: appListModel
        processConfig: shipyard.processConfigEnabled

        onDataDeleted: {
            shipyard.addDeletedData(size)
            //% "Deleted %1"
            notification.show(qsTrId("hsy-notification-deleted").arg(prettyBytes(size)))
        }

        onDeletionError: {
            notification.showPopup(
                        //% "An error occured!"
                        qsTrId("hsy-notification-error-title"),
                        //: &quot; should be replaced with real quotes
                        //% "Error deleting &quot;%1&quot;."
                        qsTrId("hsy-notification-error-body").arg(path),
                        "image://theme/icon-lock-warning")
        }
    }
}
