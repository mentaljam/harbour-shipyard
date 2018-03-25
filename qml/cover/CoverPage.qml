import QtQuick 2.0
import Sailfish.Silica 1.0


CoverBackground {

    CoverPlaceholder {
        icon.source: "/usr/share/icons/hicolor/86x86/apps/harbour-shipyard.png"
        text: {
            if (appListModel.busy) {
                //% "Working..."
                qsTrId("hsy-working")
            } else if (appListModel.unusedAppsCount > 0) {
                //% "%1 could be deleted"
                qsTrId("hsy-cover-could-be-deleted").arg(prettyBytes(
                    appListModel.unusedConfigSize + appListModel.unusedCacheSize + appListModel.unusedLocaldataSize))
            } else {
                qsTrId("hsy-rescan")
            }
        }
    }

    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-s-sync"
            onTriggered: appListModel.reset()
        }
    }
}
