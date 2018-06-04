import QtQuick 2.0

MouseArea {
    id: tipArea
    property string tip: ""

    function getAbsolutePos(item) {
        var pos = { x: 0, y: 0 };

        while (item !== null) {
            pos.x += item.x;
            pos.y += item.y;
            item = item.parent;
        }
        return pos;
    }

    anchors.fill: parent
    hoverEnabled: true

    onEntered: {
        tooltip.text = tip;
        tooltip.visible = true;
    }

    onExited: {
        tooltip.visible = false;
    }

    onMouseXChanged: {
        tooltip.x = getAbsolutePos(tipArea).x + mouseX + 15;
    }

    onMouseYChanged: {
        tooltip.y = getAbsolutePos(tipArea).y + mouseY - 2;
    }
}
