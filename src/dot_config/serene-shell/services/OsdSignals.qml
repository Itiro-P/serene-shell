pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

import qs.services

Singleton {
    id: root

    enum Kind {
        Volume,
        Muted,
        Stasis
    }

    property bool visible: false
    property int kind: OsdSignals.Kind.Volume
    property real value: 0
    property string iconName: ""
    property string message: ""

    function show(newKind, newIcon, newValue, newMsg) {
        kind = newKind;
        value = newValue;
        iconName = newIcon;
        message = newMsg;
        visible = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 1600
        onTriggered: visible = false
    }


    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSink, 
            Pipewire.defaultAudioSource
        ]
    }

    Connections {
        target: Pipewire.defaultAudioSink?.audio || null

        function onVolumeChanged() {
            let audio = Pipewire.defaultAudioSink?.audio
            let vol = audio.volume
            let icon = Utils.getNodeIcon(audio, "audio-volume")
            show(OsdSignals.Kind.Volume, icon, vol, "")
        }

        function onMutedChanged() {
            let audio = Pipewire.defaultAudioSink.audio
            let isMuted = audio.muted
            let vol = audio.volume
            let icon = Utils.getNodeIcon(audio, "audio-volume")
            show(OsdSignals.Kind.Muted, icon, vol, `Saída ${isMuted ? "sem" : "com"} áudio`)
        }
    }

    Connections {
        target: Pipewire.defaultAudioSource?.audio || null

        function onVolumeChanged() {
            let audio = Pipewire.defaultAudioSource?.audio
            let vol = audio.volume
            let icon = Utils.getNodeIcon(audio, "microphone-sensitivity")
            show(OsdSignals.Kind.Volume, icon, vol, "")
        }

        function onMutedChanged() {
            let audio = Pipewire.defaultAudioSource.audio
            let isMuted = audio.muted
            let vol = isMuted ? 0 : audio.volume
            let icon = Utils.getNodeIcon(audio, "microphone-sensitivity")
            show(OsdSignals.Kind.Muted, icon, vol, `Entrada ${isMuted ? "sem" : "com"} áudio`)
        }
    }

    Connections {
        target: Stasis

        function onInhibitedChanged() {
            if (!Stasis.running) return
            const on = Stasis.inhibited
            show(OsdSignals.Kind.Stasis,
                on ? "view-reveal-symbolic" : "view-conceal-symbolic",
                0,
                on ? "Inatividade bloqueada" : "Inatividade liberada")
        }

        function onManuallyPausedChanged() {
            if (!Stasis.running) return
            const paused = Stasis.manuallyPaused
            show(OsdSignals.Kind.Stasis,
                paused ? "media-playback-pause-symbolic" : "media-playback-start-symbolic",
                0,
                `Inatividade ${paused ? "des" : ""}ativada`)
        }
    }
}