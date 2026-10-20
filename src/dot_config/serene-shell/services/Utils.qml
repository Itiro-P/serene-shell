pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    function formatSeconds(seconds) {
        if (!seconds || seconds <= 0) return "00:00"

        const hrs = Math.floor(seconds / 3600)
        const mins = Math.floor((seconds % 3600) / 60)
        const secs = Math.floor(seconds % 60)
        const pad = n => String(n).padStart(2, '0')

        return hrs > 0
            ? `${pad(hrs)}:${pad(mins)}:${pad(secs)}`
            : `${pad(mins)}:${pad(secs)}`
    }

    function limitString(str, max) {
        if (str.length <= max) return str;
        const cut = str.slice(0, max);
        const lastSpace = cut.lastIndexOf(" ");
        return (lastSpace > 0 ? cut.slice(0, lastSpace) : cut) + "...";
    }

    function getNodeIcon(node, prefix) {
        let icon_level = "muted"
        if (node?.muted ?? true) return `${prefix}-${icon_level}-symbolic`;

        if (node.volume <= 0.0) {
            icon_level = "muted"
        } else if (node.volume < 0.5) {
            icon_level = "low"
        } else if (node.volume < 0.75) {
            icon_level = "medium"
        } else {
            icon_level = "high"
        }

        return `${prefix}-${icon_level}-symbolic`;
    }
}