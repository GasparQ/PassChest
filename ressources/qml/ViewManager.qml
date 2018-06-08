import QtQuick 2.0

Item {
    property var views: ({})
    property string url: ""
    property var currentView: null

    function refresh() {
        for (var k in views) {
            views[k].visible = (k === url);
            if (k === url) {
                currentView = views[k];
            }
        }
    }

    id: view
    anchors.fill: parent

    onViewsChanged: {
        /*for (var k in views) {
            views[k] = Qt.createComponent(views[k]).createObject(view);
        }*/
        refresh();
    }

    onUrlChanged: {
        refresh();
    }

    Component.onCompleted: {
        refresh();
    }
}
