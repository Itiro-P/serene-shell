import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Widgets

import qs.services
import qs.styles

Item {
    id: root

    visible: Mpris.player != null
    readonly property int titleMaxWidth: 220
    readonly property string trackLabel: {
        const trackTitle = Mpris.title.trim()
        const trackArtist = Mpris.artist.trim()
        const hasTitle = trackTitle && trackTitle !== "Unknown Title"
        const hasArtist = trackArtist && trackArtist !== "Unknown Artist"

        if (hasTitle && hasArtist)
            return trackTitle === trackArtist ? trackTitle : `${trackTitle} - ${trackArtist}`
        if (hasTitle)
            return trackTitle
        if (hasArtist)
            return trackArtist
        return trackTitle || trackArtist || "Unknown track"
    }

    implicitWidth: Math.min(title.implicitWidth, titleMaxWidth)
    implicitHeight: title.implicitHeight

    StyledText {
        id: title
        width: root.width
        font.pixelSize: Metrics.fontM
        elide: Text.ElideRight
        maximumLineCount: 1
        text: root.trackLabel
    }

    AnchoredPopup {
        id: popup
        anchorItem: root
        implicitWidth: Metrics.quickSettingsWidth + Metrics.spacingXxl * 3
        implicitHeight: content.implicitHeight + Metrics.paddingM * 2
        anchorEdges: Edges.Bottom
        anchorGravity: Edges.Bottom

        StyledRect {
            anchors.fill: parent

            ColumnLayout {
                id: content
                anchors.fill: parent
                anchors.margins: Metrics.paddingM
                spacing: Metrics.spacingM

                RowLayout {
                    Layout.fillWidth: true
                    spacing: Metrics.spacingL

                    StyledRect {
                        Layout.preferredWidth: Metrics.imagePreviewHeight
                        Layout.preferredHeight: Metrics.imagePreviewHeight
                        radius: Metrics.radiusL
                        color: Colors.md3.surface_container_high

                        StyledIcon {
                            anchors.centerIn: parent
                            size: Metrics.iconXl
                            source: Quickshell.iconPath("audio-x-generic-symbolic")
                            visible: !coverImage.visible
                        }

                        Image {
                            id: coverImage
                            anchors.fill: parent
                            anchors.margins: Metrics.borderThin
                            source: Mpris.player ? Mpris.player.trackArtUrl : ""
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            visible: status === Image.Ready
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: Metrics.spacingS

                        StyledText {
                            Layout.fillWidth: true
                            font.pixelSize: Metrics.fontXl
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                            maximumLineCount: 3
                            text: Mpris.title === "Unknown Title" ? root.trackLabel : Mpris.title
                        }

                        StyledText {
                            Layout.fillWidth: true
                            font.pixelSize: Metrics.fontL
                            color: Colors.md3.primary
                            elide: Text.ElideRight
                            text: Mpris.artist === "Unknown Artist" ? qsTr("Artista desconhecido") : Mpris.artist
                        }

                        StyledText {
                            id: albumLabel
                            Layout.fillWidth: true
                            font.pixelSize: Metrics.fontS
                            color: Colors.md3.on_surface_variant
                            elide: Text.ElideRight
                            text: Mpris.player && Mpris.player.trackAlbum
                                ? qsTr("Álbum: %1").arg(Mpris.player.trackAlbum)
                                : qsTr("Álbum desconhecido")
                        }

                        StyledText {
                            Layout.fillWidth: true
                            font.pixelSize: Metrics.fontS
                            color: Colors.md3.on_surface_variant
                            text: Mpris.isPlaying ? qsTr("Tocando agora") : qsTr("Pausado")
                        }
                    }
                }

                WavySlider {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Metrics.sliderHandleSize + Metrics.spacingS
                    from: 0
                    to: 1
                    value: Mpris.length > 0 ? Mpris.position / Mpris.length : 0
                    activeColor: Colors.md3.primary
                    inactiveColor: Colors.md3.surface_container_high
                    enableWave: Mpris.isPlaying && !pressed
                    onMoved: {
                        if (Mpris.player)
                            Mpris.player.position = value * Mpris.length
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    StyledText {
                        font.pixelSize: Metrics.fontS
                        color: Colors.md3.on_surface_variant
                        text: Utils.formatSeconds(Mpris.position)
                    }

                    Item { Layout.fillWidth: true }

                    StyledText {
                        font.pixelSize: Metrics.fontS
                        color: Colors.md3.on_surface_variant
                        text: Utils.formatSeconds(Mpris.length)
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Metrics.spacingXl

                    WrapperMouseArea {
                        cursorShape: Qt.PointingHandCursor
                        enabled: Mpris.player ? Mpris.player.canGoPrevious : false
                        onClicked: Mpris.previous()

                        StyledIcon {
                            size: Metrics.iconL
                            source: Quickshell.iconPath("media-skip-backward-symbolic")
                            color: parent.enabled ? Colors.md3.primary : Colors.md3.on_surface_variant
                        }
                    }

                    WrapperMouseArea {
                        cursorShape: Qt.PointingHandCursor
                        enabled: Mpris.player ? Mpris.player.canTogglePlaying : false
                        onClicked: Mpris.togglePlaying()

                        StyledIcon {
                            size: Metrics.iconXl
                            source: Quickshell.iconPath(`media-playback-${Mpris.isPlaying ? "pause" : "start"}-symbolic`)
                            color: parent.enabled ? Colors.md3.primary : Colors.md3.on_surface_variant
                        }
                    }

                    WrapperMouseArea {
                        cursorShape: Qt.PointingHandCursor
                        enabled: Mpris.player ? Mpris.player.canGoNext : false
                        onClicked: Mpris.next()

                        StyledIcon {
                            size: Metrics.iconL
                            source: Quickshell.iconPath("media-skip-forward-symbolic")
                            color: parent.enabled ? Colors.md3.primary : Colors.md3.on_surface_variant
                        }
                    }
                }
            }
        }
    }
}