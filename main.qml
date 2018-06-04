import QtQuick 2.8
import QtQuick.Window 2.2

import Chest 1.0

Window {
    visible: true
    width: 400
    height: 600
    title: qsTr("Password Chest")

    function getAbsolutePos(item) {
        var pos = { x: 0, y: 0 };

        while (item !== null) {
            pos.x += item.x;
            pos.y += item.y;
            item = item.parent;
        }
        return pos;
    }

    ListView {

        //dimension
        width: 400
        height: 600

        //style

        //data
        model: PasswordManager.passwords
        delegate: Rectangle {
            property var model: null

            //dimension
            height: data.height
            width: 400

            //style
            color: "#2e4263"
            border.color: "white"

            //content
            Row {

                //Password data
                Column {
                    id: data

                    //style
                    padding: 20

                    //dimension
                    width: 300

                    //content
                    Text {
                        //data
                        id: name
                        text: modelData.name

                        //dimension
                        width: parent.width

                        //style
                        font.pointSize: 24
                        color: "white"
                        elide: Text.ElideRight
                    }

                    Text {
                        //data
                        id: description
                        text: modelData.description

                        //dimension
                        width: parent.width - 30

                        //style
                        font.pointSize: 14
                        color: "white"
                        elide: Text.ElideRight

                        MouseArea {
                            id: descArea

                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: {
                                tooltip.text = modelData.description;
                                tooltip.visible = true;
                            }

                            onExited: {
                                tooltip.visible = false;
                            }

                            onMouseXChanged: {
                                tooltip.x = getAbsolutePos(descArea).x + mouseX + 15;
                            }

                            onMouseYChanged: {
                                tooltip.y = getAbsolutePos(descArea).y + mouseY - 2;
                            }
                        }
                    }
                }

                //Password actions
                Rectangle {
                    //dimension
                    width: 100
                    height: parent.height

                    //style
                    color: "#557bba"
                    border.color: "white"

                    MouseArea {
                        anchors.fill: parent

                        //events
                        onClicked: {
                            modelData.copyToClipboard();
                            PasswordManager.save('')
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        property alias text: txt.text

        id: tooltip

        height: txt.height
        width: txt.width

        color: "white"
        visible: false
        radius: 4

        Text {
            id: txt

            width: text.length > 50 ? 200 : text.length * font.pointSize

            //style
            padding: 4
            wrapMode: Text.WordWrap
        }
    }
}
