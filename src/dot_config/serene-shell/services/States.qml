pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    enum Opened { Launcher, Logout, WallpaperSelector, None }

    property int currentState: States.None

    readonly property bool launcherOpen: currentState === States.Launcher
    readonly property bool logoutOpen: currentState === States.Logout
    readonly property bool wallpaperSelectorOpen: currentState === States.WallpaperSelector

    function clear() { currentState = States.None }
    function set(state) { currentState = state }
    function toggle(state) { currentState = (currentState === state) ? States.None : state }
}