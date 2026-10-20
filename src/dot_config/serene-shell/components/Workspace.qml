import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Widgets

import qs.services
import qs.styles

WrapperMouseArea {
    id: root

    required property var model
    property bool isActive: model.isActive || containsMouse

    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: Niri.focusWorkspaceById(model.id)

    Rectangle {
        implicitHeight: Metrics.iconS
        implicitWidth: Metrics.iconS * (root.isActive ? 1.4 : 1)
        radius: implicitHeight / 2
        color: root.isActive ? Colors.md3.primary : Colors.md3.surface_variant

        Behavior on implicitWidth {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
}