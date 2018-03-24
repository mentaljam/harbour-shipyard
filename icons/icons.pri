# Generate PNG files

APP_SVG_ICON = $$PWD/$${TARGET}.svg
ICON_SIZES = 86 108 128 172

for(size, ICON_SIZES) {
    SIZE_NAME = $${size}x$${size}
    APP_PNG_ICONS += $$OUT_PWD/icons/$$SIZE_NAME/$${TARGET}.png
    SVG2PNG_COMMANDS += "sailfish_svg2png -z $$system(awk \"BEGIN {print $${size}/86}\") $$PWD $$OUT_PWD/icons/$$SIZE_NAME"
    icon$${size}.files = $$OUT_PWD/icons/$$SIZE_NAME/$${TARGET}.png
    icon$${size}.path = /usr/share/icons/hicolor/$$SIZE_NAME/apps
    INSTALLS += icon$${size}
}

svg2png.input = APP_SVG_ICON
svg2png.output = $$APP_PNG_ICONS
svg2png.commands = $$join(SVG2PNG_COMMANDS, " && ")
svg2png.CONFIG += no_link target_predeps combine

QMAKE_EXTRA_COMPILERS += svg2png

# Install menu icons
menu.files = $$PWD/menu
menu.path = /usr/share/$${TARGET}/icons
INSTALLS += menu

# Install donation icons
donation.files = $$PWD/donation
donation.path = /usr/share/$${TARGET}/icons
INSTALLS += donation
