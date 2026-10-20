import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import Quickshell.Widgets

RowLayout {
    id: root
    required property QtObject rootBar

    TrayMenu {
        id: trayMenu
        rootBar: root.rootBar
    }

    Repeater {
        model: SystemTray.items
        delegate: WrapperMouseArea {
            id: trayItem

            required property SystemTrayItem modelData

            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: true
            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    modelData.activate();
                } else if (mouse.button === Qt.RightButton) {
                    if (modelData.hasMenu) {
                        trayMenu.openFor(trayItem, modelData.menu);
                    } else {
                        modelData.secondaryActivate();
                    }
                }
            }

            IconImage {
                anchors.centerIn: parent
                implicitWidth: 16
                implicitHeight: 16
                source: modelData.icon ?? ""
            }
        }
    }
}