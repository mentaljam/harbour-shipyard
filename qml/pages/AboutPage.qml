import QtQuick 2.0
import Sailfish.Silica 1.0


Page {

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingMedium

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: header
                //% "About Shipyard"
                title: qsTrId("hsy-about")
            }

            Item {
                height: icon.height + Theme.paddingMedium
                width: parent.width

                Image {
                    id: icon
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "/usr/share/icons/hicolor/128x128/apps/harbour-shipyard.png"
                }
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.highlightColor
                text: qsTrId("hsy-shipyard") + " " + Qt.application.version
            }

            Label {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.horizontalPageMargin
                }
                height: implicitHeight + Theme.paddingMedium
                color: Theme.highlightColor
                linkColor: Theme.primaryColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                horizontalAlignment: Qt.AlignHCenter
                text:
                    //% "<p>Shipyard helps you to manage data of your Sailfish&nbsp;OS device.</p>"
                    //% "<p>This is an open source software which is distributed "
                    //% "under the terms of the <a href='%1'>MIT&nbsp;License</a>.</p>"
                    qsTrId("hsy-app-description").arg("https://github.com/mentaljam/harbour-shipyard/blob/master/LICENSE")
                onLinkActivated: Qt.openUrlExternally(link)
            }

            ButtonLayout {
                width: parent.width

                Button {
                    //% "Development"
                    text: qsTrId("hsy-development")
                    onClicked: pageStack.push(Qt.resolvedUrl("DevelopmentPage.qml"))
                }

                Button {
                    //% "Translations"
                    text: qsTrId("hsy-translations")
                    onClicked: Qt.openUrlExternally("https://www.transifex.com/mentaljam/harbour-shipyard")
                }
            }
        }
    }
}
