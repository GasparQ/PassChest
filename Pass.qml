import QtQuick 2.8

import Chest 1.0

Item {
    id: pass
    property string name: ""
    property string description: ""

    signal copyToClipboard()
    signal edit()
    signal remove()

    height: data.height
    width: 400

    //content
    Row {
        //Password data
        Rectangle {
            height: data.height
            width: data.width

            //style
            color: "#2e4263"
            border.color: "white"

            //Texts
            Column {
                id: data

                //style
                padding: 20

                //dimension
                width: 400

                //name
                Text {
                    //data
                    text: name

                    //dimension
                    width: parent.width

                    //style
                    font.pointSize: 24
                    color: "white"
                    elide: Text.ElideRight
                }

                //description
                Text {
                    //data
                    text: description

                    //dimension
                    width: parent.width - 30

                    //style
                    font.pointSize: 14
                    color: "white"
                    elide: Text.ElideRight

                    //tooltipable
                    TooltipArea {
                        tip: description
                    }
                }
            }

            //Events
            MouseArea {
                width: data.width
                height: data.height
                hoverEnabled: true

                onClicked: {
                    if (pass.x == 0)
                        pass.x = -300;
                    else
                        pass.x = 0;
                }

                onEntered: {
                    data.parent.color = "#4869a0"
                }

                onExited: {
                    data.parent.color = "#2e4263"
                }
            }
        }

        //Password actions
        Rectangle {
            //dimension
            width: 300
            height: data.height

            Row {
                anchors.fill: parent

                //copy to clipboard
                ActionButton {
                    width: 100
                    height: parent.height

                    defaultColor: "#557bba";
                    iconUrl: "icons/copytoclipboard.png"
                    border.color: "white"

                    onClicked: {
                        pass.copyToClipboard();
                    }
                }

                //edit
                ActionButton {
                    width: 100
                    height: parent.height

                    defaultColor: "#557bba";
                    iconUrl: "icons/edit.png"
                    border.color: "white"

                    onClicked: {
                        pass.edit();
                    }
                }

                //remove
                ActionButton {
                    width: 100
                    height: parent.height

                    defaultColor: "#557bba";
                    iconUrl: "icons/remove.png"
                    border.color: "white"

                    onClicked: {
                        pass.remove();
                    }
                }
            }
        }
    }
}
