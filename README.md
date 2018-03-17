# Shipyard

Manage data of your Sailfish OS device.

## Translations

You can help to localize harbour-shipyard to your language using [Transifex](https://www.transifex.com/mentaljam/harbour-shipyard) or [Qt Linguist](http://doc.qt.io/qt-5/qtlinguist-index.html).

Note that harbour-shipyard translations are **ID based** Qt ts files. So if you want to compile a translation file for testing you should run the lrelease command with the "-idbased" option, for example:

    lrelease -idbased harbour-shipyard.ts

If you want to test your translation before publishing you should compile it and place produced qm file to (root access is required)

    /usr/share/harbour-shipyard/translations

The application tries to load translation files automatically basing on your system locale settings. Also you can run application with selected locale from terminal. For example for Russian language the command is

    LANG=ru harbour-shipyard
