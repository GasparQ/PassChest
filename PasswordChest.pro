QT += quick
QT += widgets
CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    src/botancipher.cpp \
    src/main.cpp \
    src/password.cpp \
    src/passwordmanager.cpp

RESOURCES += ressources/qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    include/botancipher.h \
    include/password.h \
    include/passwordmanager.h

INCLUDEPATH += $$PWD/include/

DISTFILES += \
    config/config.xml \
    packages/com.vendor.product/meta/package.xml \
    passchest.rc \
    packages/com.vendor.product/meta/installscript.qs

RC_FILE = $$PWD/passchest.rc

target.path = $$PWD/packages/com.vendor.product/data/
botan.files = $$PWD/ressources/binaries/botan*
botan.path = $$PWD/packages/com.vendor.product/data/

INSTALLS += target
INSTALLS += botan
