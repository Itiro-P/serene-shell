import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import qs.services
import qs.styles

WrapperRectangle {
    id: root

    required property QtObject rootBar

    color: Colors.md3.on_primary
    margin: Metrics.spacingXs
    radius: implicitHeight / 2

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        spacing: Metrics.spacingS

        Repeater {
            model: Niri.workspaces

            delegate: Workspace {}
        }
    }
}