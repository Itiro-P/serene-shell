import Quickshell
import QtQuick
import Quickshell.Widgets

import qs.services
import qs.styles

WrapperItem {
    id: root

    Rectangle {
        id: button

        implicitWidth: Metrics.iconM
        implicitHeight: Metrics.iconM
        radius: implicitHeight / 2

        color: !Stasis.running ? "transparent"
             : Stasis.manuallyPaused ? Colors.md3.primary_container
             : Colors.md3.surface_container_high

        Behavior on color { ColorAnimation { duration: 150 } }

        readonly property color contentColor: !Stasis.running ? Colors.md3.outline
                                            : Stasis.manuallyPaused ? Colors.md3.on_primary_container
                                            : Colors.md3.on_surface_variant

        // camada de hover
        Rectangle {
            anchors.fill: parent
            radius: button.radius
            color: button.contentColor
            opacity: mouse.containsMouse ? 0.08 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        StyledIcon {
            anchors.centerIn: parent
            size: Metrics.iconS
            color: button.contentColor
            source: Quickshell.iconPath(
                Stasis.manuallyPaused ? "view-reveal-symbolic" : "view-conceal-symbolic",
                true)
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            enabled: Stasis.running
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: Stasis.toggleInhibit()
        }
    }
}