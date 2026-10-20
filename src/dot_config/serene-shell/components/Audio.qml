import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.styles
import qs.services

WrapperItem {
    id: root
    property PwNode defaultSink: Pipewire.defaultAudioSink
    property PwNode defaultSource: Pipewire.defaultAudioSource
    property string sinkIcon: Utils.getNodeIcon(defaultSink?.audio, "audio-volume")
    property string sourceIcon: Utils.getNodeIcon(defaultSource?.audio, "microphone-sensitivity")

    PwObjectTracker {
        objects: [
            root.defaultSink,
            root.defaultSource
        ]
    }

    function setVolume(node, delta) {
        if (node) node.volume = Math.max(0, Math.min(1, node.volume + delta * 0.02));
    }

    function toggleMute(node) {
        if (node) node.muted = !node.muted;
    }

    RowLayout {
        WrapperMouseArea {
            id: sinkItem
            onClicked: toggleMute(defaultSink?.audio)
            cursorShape: Qt.PointingHandCursor

            RowLayout {
                id: sinkRow
                StyledIcon {
                    size: Metrics.iconS
                    source: `image://icon/${sinkIcon}`
                    color: Colors.md3.primary
                }
                StyledText {
                    font.pixelSize: Metrics.fontM
                    text: defaultSink?.audio ? `${Math.round(defaultSink.audio.volume * 100)}%` : "--"
                }
            }

            WheelHandler {
                target: sinkItem
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: (event) => {
                    const delta = event.angleDelta.y / 120;
                    setVolume(defaultSink?.audio, delta);
                }
            }
        }

        WrapperMouseArea {
            id: sourceItem
            onClicked: toggleMute(defaultSource?.audio)
            cursorShape: Qt.PointingHandCursor

            RowLayout {
                id: sourceRow
                StyledIcon {
                    size: Metrics.iconS
                    source: `image://icon/${sourceIcon}`
                    color: Colors.md3.primary
                }
                StyledText {
                    font.pixelSize: Metrics.fontM
                    text: defaultSource?.audio ? `${Math.round(defaultSource.audio.volume * 100)}%` : "--"
                }
            }


            WheelHandler {
                target: sourceItem
                acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                onWheel: (event) => {
                    const delta = event.angleDelta.y / 120;
                    setVolume(defaultSource?.audio, delta);
                }
            }
        }

        WrapperMouseArea {
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.execDetached(["pavucontrol"])
            IconImage {
                implicitWidth: Metrics.iconS
                implicitHeight: Metrics.iconS
                source: "image://icon/settings-symbolic"
            }
        }
    }
}
