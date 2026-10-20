import QtQuick
import QtQuick.Effects

import qs.styles

Item {
    id: root

    property string source: ""
    property color color: Colors.md3.primary
    property int size: Metrics.iconM

    Behavior on color { ColorAnimation { duration: 150 } }

    implicitWidth: size
    implicitHeight: size

    Image {
        id: img
        anchors.fill: parent
        visible: false
        source: root.source
        sourceSize: Qt.size(root.size * Screen.devicePixelRatio,
                            root.size * Screen.devicePixelRatio)
    }

    MultiEffect {
        anchors.fill: parent
        source: img
        colorization: 1.0
        colorizationColor: root.color
    }
}