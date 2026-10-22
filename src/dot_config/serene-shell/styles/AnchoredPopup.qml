import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.styles

PopupWindow {
    id: root

    required property Item anchorItem
    required property var anchorEdges
    required property var anchorGravity
    property var anchorAdjustment: PopupAdjustment.SlideX | PopupAdjustment.SlideY
    property real progress: 0
    color: "transparent"
    contentItem.opacity: progress
    contentItem.transform: Translate {
        y: -14 * (1 - root.progress)
    }

    Behavior on progress {
        NumberAnimation {
            duration: 120
            easing.type: root.progress > 0 ? Easing.OutCubic : Easing.InCubic
        }
    }

    anchor {
        item: root.anchorItem
        edges: root.anchorEdges
        gravity: root.anchorGravity
        adjustment: root.anchorAdjustment
    }

    onVisibleChanged: {
        if (visible) {
            hideTimer.stop()
            progress = 1
        } else if (popupHover.hovered || anchorHover.hovered) {
            showPopup()
        }
    }

    function showPopup() {
        hideTimer.stop()
        if (!visible) {
            visible = true
        }
        progress = 1
    }

    function closeIfPointerOutside() {
        if (popupHover.hovered || anchorHover.hovered)
            return

        progress = 0
        hideTimer.restart()
    }

    HoverHandler {
        id: popupHover
        onHoveredChanged: {
            if (hovered) {
                closeTimer.stop()
                root.showPopup()
            } else {
                closeTimer.restart()
            }
        }
    }

    HoverHandler {
        id: anchorHover
        parent: root.anchorItem
        onHoveredChanged: {
            if (hovered) {
                closeTimer.stop()
                root.showPopup()
            } else {
                closeTimer.restart()
            }
        }
    }

    Timer {
        id: closeTimer
        interval: 300
        onTriggered: root.closeIfPointerOutside()
    }

    Timer {
        id: hideTimer
        interval: 240
        onTriggered: {
            if (!popupHover.hovered && !anchorHover.hovered)
                root.visible = false
        }
    }

}
