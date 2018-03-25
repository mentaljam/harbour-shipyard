include(known_apps/known_apps.pri)

TARGET = harbour-shipyard

CONFIG += sailfishapp

QT += concurrent

OBJECTS_DIR = obj
MOC_DIR = moc

HEADERS += \
    src/shipyard.h \
    src/applistitem.h \
    src/applistmodel.h \
    src/proxymodel.h

SOURCES += \
    src/shipyard.cpp \
    src/harbour-shipyard.cpp \
    src/applistmodel.cpp \
    src/proxymodel.cpp

# Write version file
VERSION_H = \
"$${LITERAL_HASH}ifndef SHIPYARD_VERSION" \
"$${LITERAL_HASH}   define SHIPYARD_VERSION \"$$VERSION\"" \
"$${LITERAL_HASH}endif"
write_file($$$$OUT_PWD/shipyard_version.h, VERSION_H)

CONFIG(release, debug|release): DEFINES += QT_NO_DEBUG_OUTPUT

# If safe_mode is set then Shipyard wouldn't really delete files
CONFIG(safe_mode): DEFINES += SAFE_MODE

DISTFILES += \
    qml/harbour-shipyard.qml \
    qml/cover/CoverPage.qml \
    qml/pages/MainPage.qml \
    qml/pages/SettingsPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/DevelopmentPage.qml \
    qml/pages/CleanerPage.qml \
    qml/pages/CleanerConfirmationDialog.qml \
    qml/pages/CleanerItemsPage.qml \
    qml/components/HintLabel.qml \
    qml/components/Hint.qml \
    qml/components/MainPageButton.qml \
    qml/components/ListMenuItem.qml \
    qml/components/CleanerDashboard.qml \
    qml/components/CleanerDataLabel.qml \
    qml/components/CleanerItems.qml \
    qml/components/CleanerItemDelegate.qml \
    qml/components/CleanerSizeLabel.qml \
    qml/components/CleanerPageMenu.qml \
    qml/models/DevelopersModel.qml \
    rpm/harbour-shipyard.changes \
    rpm/harbour-shipyard.yaml \
    translations/*.ts \
    harbour-shipyard.desktop \
    .tx/config \
    .gitignore \
    LICENSE \
    README.md

CONFIG += \
    sailfishapp_i18n \
    sailfishapp_i18n_idbased \
    sailfishapp_i18n_unfinished

TRANSLATIONS += \
    translations/harbour-shipyard.ts \
    translations/harbour-shipyard-de_DE.ts \
    translations/harbour-shipyard-es.ts \
    translations/harbour-shipyard-hu.ts \
    translations/harbour-shipyard-nl.ts \
    translations/harbour-shipyard-pt_BR.ts \
    translations/harbour-shipyard-ru.ts \
    translations/harbour-shipyard-sv.ts

include(icons/icons.pri)
