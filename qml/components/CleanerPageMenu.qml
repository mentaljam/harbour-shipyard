import QtQuick 2.0
import Sailfish.Silica 1.0


PullDownMenu {
    busy: appListModel.busy

    MenuItem {
        enabled: _canDeleteUnused
        //% "Delete unused data"
        text: qsTrId("hsy-delete")
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/CleanerConfirmationDialog.qml"))
    }

    MenuItem {
        enabled: !appListModel.busy
        //% "Rescan"
        text: qsTrId("hsy-rescan")
        onClicked: appListModel.reset()
    }
}
