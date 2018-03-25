import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.shipyard 1.0
import "../components"


Page {
    id: page

    onOrientationTransitionRunningChanged: {
        if (!orientationTransitionRunning && isLandscape) {
            pageStack.navigateBack(PageStackAction.Immediate)
        }
    }

    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: appListModel.resetting
    }

    CleanerItems {
        anchors.fill: parent
    }
}
