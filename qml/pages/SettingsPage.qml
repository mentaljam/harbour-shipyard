import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"


Page {

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingMedium

        Column {
            id: column
            width: parent.width

            PageHeader {
                id: header
                //% "Settings"
                title: qsTrId("hsy-settings")
            }

            SectionHeader {
                //% "Counters"
                text: qsTrId("hsy-counters")
            }

            ListMenuItem {
                enabled: shipyard.totalDeletedData > 0
                iconSource: "image://theme/icon-m-delete"
                //% "Reset the counter of deleted data"
                text: qsTrId("hsy-reset-counter")
                //% "Resetting"
                onClicked: remorseAction(qsTrId("hsy-resetting"), function() {
                    shipyard.resetDeletedData()
                })
            }

            SectionHeader {
                //: A section name of the settings page
                //% "Advanced"
                text: qsTrId("hsy-advanced")
            }

            TextSwitch {
                id: advancedSwitch
                checked: shipyard.advancedOptionsEnabled
                //% "Enable advanced options"
                text: qsTrId("hsy-show-enabled")

                onCheckedChanged: shipyard.advancedOptionsEnabled = checked
            }

            TextSwitch {
                id: processConfigSwitch
                visible: opacity > 0.0
                opacity: advancedSwitch.checked ? 1.0 : 0.0
                checked: shipyard.processConfigEnabled
                //% "Process configuration files"
                text: qsTrId("hsy-allow-process-config")
                //% "By default only cache and local data are processed"
                description: qsTrId("hsy-allow-process-config-note")

                onCheckedChanged: shipyard.processConfigEnabled = checked

                Behavior on opacity { FadeAnimation { } }

                // A workaround as not all the signals are emitted
                Connections {
                    target: shipyard
                    onDeleteAllDataAllowedChanged: {
                        if (processConfigSwitch.checked !== shipyard.processConfigEnabled) {
                            processConfigSwitch.checked = shipyard.processConfigEnabled
                        }
                    }
                }
            }

            TextSwitch {
                id: allowDeleteSwitch
                visible: opacity > 0.0
                opacity: advancedSwitch.checked ? 1.0 : 0.0
                checked: shipyard.deleteAllDataAllowed
                //% "Allow delete all data for installed applications"
                text: qsTrId("hsy-allow-delete-all")
                //% "By default only cache can be deleted"
                description: qsTrId("hsy-allow-delete-all-note")

                onCheckedChanged: shipyard.deleteAllDataAllowed = checked

                Behavior on opacity { FadeAnimation { } }

                // A workaround as not all the signals are emitted
                Connections {
                    target: shipyard
                    onDeleteAllDataAllowedChanged: {
                        if (allowDeleteSwitch.checked !== shipyard.deleteAllDataAllowed) {
                            allowDeleteSwitch.checked = shipyard.deleteAllDataAllowed
                        }
                    }
                }
            }
        }
    }
}
