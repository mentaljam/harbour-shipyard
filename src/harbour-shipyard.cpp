#include <QtQuick>

#include <sailfishapp.h>

#include <shipyard_version.h>
#include "shipyard.h"
#include "applistmodel.h"
#include "proxymodel.h"


int main(int argc, char *argv[])
{
    qmlRegisterType<Shipyard>    ("harbour.shipyard", 1, 0, "Shipyard");
    qmlRegisterType<AppListModel>("harbour.shipyard", 1, 0, "AppListModel");
    qmlRegisterType<ProxyModel>  ("harbour.shipyard", 1, 0, "ProxyModel");
    qRegisterMetaType<QVector<int>>();

    auto app = SailfishApp::application(argc, argv);
    app->setApplicationVersion(QStringLiteral(SHIPYARD_VERSION));

    {
        auto *translator = new QTranslator(app);
        auto path = SailfishApp::pathTo(QStringLiteral("translations")).toLocalFile();
        auto name = app->applicationName();
        // Check if translations have been already loaded
        if (!translator->load(QLocale::system(), name, "-", path))
        {
            // Load default translations if not
            translator->load(name, path);
            app->installTranslator(translator);
        }
        else
        {
            translator->deleteLater();
        }
    }

    auto view = SailfishApp::createView();
    view->setSource(SailfishApp::pathToMainQml());
    view->show();

    return app->exec();
}
