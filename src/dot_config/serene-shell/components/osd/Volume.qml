import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.services
import qs.styles

WrapperItem {
    id: root

    leftMargin: Metrics.paddingM

    RowLayout {
        spacing: Metrics.spacingS

        StyledIcon {
            size: Metrics.iconL
            source: Quickshell.iconPath(OsdSignals.iconName)
            Layout.alignment: Qt.AlignVCenter
            color: Colors.md3.primary
        }

        Text {
            text: `${Math.round(OsdSignals.value * 100)}%`
            font.pixelSize: Metrics.fontS
            font.bold: true
            color: Colors.md3.primary
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            implicitWidth: 200
            implicitHeight: 12
            radius: Metrics.radiusL
            color: Colors.md3.on_primary
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

                width: parent.width * Math.max(0, Math.min(1, OsdSignals.value))
                radius: parent.radius
                color: Colors.md3.primary

                Behavior on width { NumberAnimation { duration: 100 } }
            }
        }
    }
}