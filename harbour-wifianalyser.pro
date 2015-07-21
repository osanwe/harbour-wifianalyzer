# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-wifianalyser

CONFIG += sailfishapp

SOURCES += src/harbour-wifianalyser.cpp \
    src/wpaclihelper.cpp

OTHER_FILES += qml/harbour-wifianalyser.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-wifianalyser.changes.in \
    rpm/harbour-wifianalyser.spec \
    rpm/harbour-wifianalyser.yaml \
    translations/*.ts \
    harbour-wifianalyser.desktop \
    qml/pages/GraphPage.qml \
    qml/pages/PasswordPage.qml \
    qml/pages/AboutPage.qml \
    qml/pages/ListPage.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
#TRANSLATIONS += translations/harbour-wifianalyser-de.ts
TRANSLATIONS += translations/harbour-wifianalyser-ru.ts \
    translations/harbour-wifianalyser-sv.ts

HEADERS += \
    src/wpaclihelper.h

