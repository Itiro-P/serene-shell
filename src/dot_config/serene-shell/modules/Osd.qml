import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland

import qs.services
import qs.components.osd
import qs.styles

Scope {
    id: root

    property real progress: OsdSignals.visible ? 1 : 0

    Behavior on progress {
        NumberAnimation {
            duration: 240
            easing.type: OsdSignals.visible ? Easing.OutCubic : Easing.InCubic
        }
    }

    LazyLoader {
        active: OsdSignals.visible || root.progress > 0

        PanelWindow {
            WlrLayershell.layer: WlrLayer.Overlay
            anchors {
                top: true
            }
            exclusiveZone: 0

            implicitWidth: wrapper.implicitWidth
            implicitHeight: wrapper.implicitHeight

            color: "transparent"
            mask: Region {}

            WrapperItem {
                id: wrapper

                opacity: root.progress
                transform: Translate {
                    y: -wrapper.height * (1 - root.progress)
                }

                StyledRect {
                    id: styledRect
                    radius: Metrics.radiusL * 2

                    implicitWidth: stack.currentItem ? stack.currentItem.implicitWidth + Metrics.paddingL : 240
                    implicitHeight: stack.currentItem ? stack.currentItem.implicitHeight + Metrics.paddingL : 60

                    StackLayout {
                        id: stack
                        anchors.fill: parent
                        currentIndex: OsdSignals.kind

                        readonly property Item currentItem: children[currentIndex]

                        Volume {}
                        Muted {}
                        StasisOsd {}
                    }
                }
            }
        }
    }
}