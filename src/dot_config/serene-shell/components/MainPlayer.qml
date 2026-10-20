import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets

import qs.services
import qs.styles

Item {
    id: root
    visible: Mpris.player != null
    implicitWidth: stack.implicitWidth
    implicitHeight: stack.implicitHeight

    HoverHandler {
        id: hover
    }

    StackLayout {
        id: stack
        currentIndex: hover.hovered
        
        StyledText {
            font.pixelSize: Metrics.fontM
            text: `${Utils.limitString(Mpris.title, 20)} - ${Utils.limitString(Mpris.artist, 20)}`
        }

        RowLayout {
            spacing: Metrics.spacingM

            WrapperMouseArea {
                cursorShape: Qt.PointingHandCursor
                onClicked: Mpris.previous()

                StyledIcon {
                    size: Metrics.iconS
                    source: Quickshell.iconPath("media-skip-backward-symbolic")
                }
            }

            WrapperMouseArea {
                cursorShape: Qt.PointingHandCursor
                onClicked: Mpris.togglePlaying()

                StyledIcon {
                    size: Metrics.iconS
                    source: Quickshell.iconPath(`media-playback-${Mpris.isPlaying ? "pause" : "start"}-symbolic`)
                }
            }

            WrapperMouseArea {
                cursorShape: Qt.PointingHandCursor
                onClicked: Mpris.next()

                StyledIcon {
                    size: Metrics.iconS
                    source: Quickshell.iconPath("media-skip-forward-symbolic")
                }
            }

            StyledText {
                text: `${Utils.formatSeconds(Mpris.position)} - ${Utils.formatSeconds(Mpris.length)}`
            }
        }
    }
}