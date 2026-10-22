pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string state: "not_running"
    property bool paused: false
    property bool manuallyPaused: false
    property string profile: ""

    readonly property bool running: state !== "not_running"
    readonly property bool locked: state === "locked"
    readonly property bool inhibited: state === "inhibited" || state === "manual"

    function update(raw) {
        let data
        try {
            data = JSON.parse(raw)
        } catch (e) {
            console.warn("stasis: JSON inválido:", raw, e)
            return
        }

        state = data.state ?? "not_running"
        paused = data.paused ?? false
        manuallyPaused = data.manually_paused ?? false
        profile = data.profile ?? ""
    }

    function pause() {
        Quickshell.execDetached(["stasis", "pause"])
    }

    function resume() {
        Quickshell.execDetached(["stasis", "resume"])
    }

    function toggleInhibit() {
        Quickshell.execDetached(["stasis", "toggle-inhibit"])
    }

    Process {
        id: watcher
        command: ["stasis", "watch"]
        running: true

        stdout: SplitParser {
            onRead: line => root.update(line)
        }

        onRunningChanged: {
            if (!running) {
                root.state = "not_running"
                root.paused = false
                root.manuallyPaused = false
                restartTimer.start()
            }
        }
    }

    Timer {
        id: restartTimer
        interval: 2000
        onTriggered: watcher.running = true
    }
}