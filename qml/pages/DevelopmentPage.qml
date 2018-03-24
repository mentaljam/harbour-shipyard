import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0
import "../models"

Page {

    SilicaListView {
        anchors.fill: parent
        model: DevelopersModel { }

        header: PageHeader {
            //% "Development"
            title: qsTrId("hsy-development")
        }

        delegate: Item {
            width: parent.width
            height: column.height + Theme.paddingLarge

            Column {
                id: column
                x: Theme.horizontalPageMargin
                width: parent.width - Theme.horizontalPageMargin * 2
                anchors.verticalCenter: parent.verticalCenter
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: nameTouchArea.pressed ? Theme.highlightColor : Theme.primaryColor
                    text: name

                    MouseArea {
                        id: nameTouchArea
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally(link)
                    }
                }

                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: role
                }

                Label {
                    width: parent.width
                    wrapMode: Text.WordWrap
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    //% "Donate with"
                    text: qsTrId("hsy-donate-with")
                }

                Grid {
                    width: parent.width
                    spacing: Theme.paddingMedium

                    Repeater {
                        model: donation

                        MouseArea {
                            id: delegateItem
                            implicitWidth: delegateImage.implicitWidth + delegateLabel.contentWidth
                            implicitHeight: Math.max(delegateImage.implicitHeight, delegateLabel.implicitHeight)
                            onClicked: Qt.openUrlExternally(model.link)

                            Image {
                                id: delegateImage
                                anchors.verticalCenter: parent.verticalCenter
                                source: "/usr/share/harbour-shipyard/icons/donation/" + model.icon
                            }

                            ColorOverlay {
                                anchors.fill: delegateImage
                                source: delegateImage
                                color: delegateItem.pressed ? Theme.highlightColor : Theme.primaryColor
                            }

                            Label {
                                id: delegateLabel
                                anchors {
                                    left: delegateImage.right
                                    verticalCenter: parent.verticalCenter
                                }
                                color: delegateItem.pressed ? Theme.highlightColor : Theme.primaryColor
                                font.pixelSize: Theme.fontSizeExtraSmall
                                text: model.name
                            }
                        }
                    }
                }
            }
        }

        PullDownMenu {

            MenuItem {
                text: "GitHub"
                onClicked: Qt.openUrlExternally("https://github.com/mentaljam/harbour-shipyard")
            }
        }

        VerticalScrollDecorator { }
    }
}
