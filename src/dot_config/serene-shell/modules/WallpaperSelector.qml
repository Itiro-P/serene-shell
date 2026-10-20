import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick.Effects

import qs.services
import qs.components
import qs.styles

Scope {
    id: root
    property real progress: States.wallpaperSelectorOpen ? 1 : 0

    Behavior on progress {
        NumberAnimation {
            duration: 120
            easing.type: States.wallpaperSelectorOpen ? Easing.InCubic : Easing.OutCubic
        }
    }

    LazyLoader {
        active: States.wallpaperSelectorOpen || root.progress > 0

        PanelWindow {
            id: selectorWindow
            WlrLayershell.layer: WlrLayer.Overlay

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            color: "transparent"
            aboveWindows: true 
            focusable: true

            MouseArea {
                anchors.fill: parent
                onClicked: States.clear()
            }

            Shortcut {
                sequence: "Escape"
                onActivated: States.clear()
            }

            Rectangle {
                id: content
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                color: Colors.md3.surface
                
                implicitHeight: Metrics.imagePreviewHeight + (Metrics.paddingS * 2)
                implicitWidth: Metrics.imagePreviewWidth * 5 + Metrics.paddingL
                
                radius: Metrics.radiusL
                
                opacity: root.progress
                transform: Translate {
                    y: content.height * (1 - root.progress)
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {} // Impede o fechamento ao clicar no painel
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: Metrics.paddingS
                    
                    ListView {
                        id: resultsList
                        focus: true // Garante o recebimento de eventos de teclado
                        Layout.fillWidth: true
                        Layout.preferredHeight: Metrics.imagePreviewHeight
                        orientation: ListView.Horizontal
                        spacing: Metrics.spacingS
                        clip: true
                        model: Awww.wallpapers
                        keyNavigationEnabled: true
                        
                        Keys.onReturnPressed: {
                            if (currentItem) {
                                States.clear();
                                Awww.apply(screen.name, currentItem.modelData.filePath);
                            }
                        }
                        delegate: WallpaperPreview { output: screen.name }
                    }
                }
            }
        }
    }
}