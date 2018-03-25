import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.shipyard 1.0


SilicaListView {
    id: listView
    opacity: !appListModel.resetting ? 1.0 : 0.0
    visible: opacity === 1.0

    Behavior on opacity { FadeAnimation { } }

    model: ProxyModel {
        id: proxyModel
        sortRole: AppListModel.SortRole
        sortCaseSensitivity: Qt.CaseInsensitive
        dynamicSortFilter: true
        sourceModel: appListModel
        onSourceModelChanged: sort(Qt.AscendingOrder)
    }

    header: PageHeader {
        visible: isPortrait
        height: visible ? _preferredHeight : 0.0
        title: qsTrId("hsy-found")
        description:
            //% "%1 of data"
            qsTrId("hsy-of-data").arg(prettyBytes(appListModel.totalConfigSize +
                                                  appListModel.totalCacheSize +
                                                  appListModel.totalLocaldataSize)) + " " +
            //% "of %n application(s)"
            qsTrId("hsy-of-apps", appListModel.totalAppsCount)
    }

    section {
        property: "installed"
        delegate: SectionHeader {
            text: section === "true" ?
                      //% "Installed"
                      qsTrId("hsy-installed") :
                      //% "Uninstalled"
                      qsTrId("hsy-uninstalled")
        }
    }

    delegate: CleanerItemDelegate { }

    CleanerPageMenu {
        id: menu        
        visible: isPortrait
    }

    VerticalScrollDecorator { }
}
