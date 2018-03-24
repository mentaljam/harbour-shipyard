import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"


Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: header.height + content.height

        PullDownMenu {

            MenuItem {
                text: qsTrId("hsy-about")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }

            MenuItem {
                text: qsTrId("hsy-settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }
        }

        PageHeader {
            id: header
            //% "Shipyard"
            title: qsTrId("hsy-shipyard")
        }

        Grid {
            id: content
            anchors.top: header.bottom
            width: page.width
            spacing: Theme.paddingMedium

            MainPageButton {
                text: qsTrId("hsy-cleaning")
                iconSource: "/usr/share/harbour-shipyard/icons/menu/icon-l-cleaning-mop.png"
                onClicked: pageStack.push(Qt.resolvedUrl("CleanerPage.qml"))
            }
        }
    }
}
