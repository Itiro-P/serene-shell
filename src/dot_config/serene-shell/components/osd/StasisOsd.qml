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

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            text: OsdSignals.message
            font.pixelSize: Metrics.fontTitleMedium
        }
    }
}