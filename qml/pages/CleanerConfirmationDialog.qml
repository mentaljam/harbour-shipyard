import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.shipyard 1.0


Dialog {
    id: dialog
    canAccept: switch2.checked

    onStatusChanged: {
        if (status === DialogStatus.Closed && result === DialogResult.Accepted) {
            cleanerModel.deleteUnusedData(shipyard.processConfigEnabled ?
                                              CleanerListModel.AllData :
                                              CleanerListModel.CacheData | CleanerListModel.LocalData)
        }
    }

    DialogHeader {
        id: header
    }

    SilicaFlickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentHeight: content.height

        Column {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            Label {
                id: label
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.horizontalPageMargin
                }
                color: Theme.highlightColor
                wrapMode: Text.WordWrap
                //% "<h3>Warning!</h3><br />"
                //% "<p>This action can damage your device. You accept it solely at your own risk!</p>"
                text: qsTrId("hsy-confirmation-warning")
            }

            TextSwitch {
                id: switch1
                //% "I understand the risks"
                text: qsTrId("hsy-understand1")
            }

            TextSwitch {
                id: switch2
                visible: opacity > 0.0
                opacity: switch1.checked ? 1.0 : 0.0
                //% "I completely understand the risks"
                text: qsTrId("hsy-understand2")

                onVisibleChanged: if (!visible) checked = false

                Behavior on opacity { FadeAnimation { } }
            }
        }
    }
}
