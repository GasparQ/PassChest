import QtQuick 2.0

Rectangle {
    property color defaultColor: "red"
    property color hoverColor: Qt.lighter(defaultColor)
    property color clickColor: defaultColor

    property string iconUrl: ""

    id: button

    signal clicked()
    signal pressed()
    signal released()
    signal entered()
    signal exited()

    width: 100
    height: 100

    color: defaultColor

    Image {
        anchors.centerIn: parent
        source: iconUrl
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            button.clicked();
        }

        onPressed: {
            button.color = clickColor;
            button.pressed();
        }

        onReleased: {
            button.color = hoverColor;
            button.released();
        }

        onEntered: {
            button.color = hoverColor;
            button.entered();
        }

        onExited: {
            button.color = defaultColor;
            button.exited();
        }
    }
}
