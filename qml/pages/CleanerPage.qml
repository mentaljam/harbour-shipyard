import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.shipyard 1.0
import "../components"


Page {

    function _updateUi() {
        if (status === PageStatus.Active) {
            if (isPortrait) {
                if (!canNavigateForward) {
                    pageStack.pushAttached(Qt.resolvedUrl("CleanerItemsPage.qml"))
                }
            } else if (canNavigateForward) {
                pageStack.popAttached()
            }
        }
    }

    function _showHints() {
        if (isPortrait && status === PageStatus.Active &&
                shipyard.showHint(Shipyard.OpenEntriesPage)) {
            var hintComp = Qt.createComponent(Qt.resolvedUrl("../components/Hint.qml"))
            var hintObj = hintComp.createObject(cleanerPage, {direction: TouchInteraction.Left})

            var labelComp = Qt.createComponent(Qt.resolvedUrl("../components/HintLabel.qml"))
            var labelObj = labelComp.createObject(cleanerPage, {
                                                      hint: hintObj,
                                                      //% "Swipe to see details"
                                                      text: qsTrId("hsy-hint-openentriespage"),
                                                      "anchors.bottom": cleanerPage.bottom
                                                  })

            labelObj.finished.connect(function() {
                shipyard.setHintShowed(Shipyard.OpenEntriesPage)
                labelObj.destroy()
                hintObj.destroy()
            })

            hintObj.start()
        }
    }

    id: cleanerPage

    onOrientationTransitionRunningChanged: {
        if (!orientationTransitionRunning) {
            _updateUi()
            _showHints()
        }
    }

    onStatusChanged: {
        _updateUi()
        _showHints()
    }

    BusyIndicator {
        size: BusyIndicatorSize.Large
        anchors.centerIn: parent
        running: appListModel.resetting
    }

    Loader {
        id: loader
        visible: !appListModel.resetting
        anchors.fill: parent
        sourceComponent: isPortrait ? singlePaneComponent : doublePaneComponent
    }

    Component {
        id: singlePaneComponent

        CleanerDashboard {
            anchors.fill: parent
        }
    }

    Component {
        id: doublePaneComponent

        Item {
            anchors.fill: parent

            CleanerDashboard {
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.horizontalCenter
                    bottom: parent.bottom
                }
            }

            CleanerItems {
                anchors {
                    left: parent.horizontalCenter
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                }
            }
        }
    }
}
