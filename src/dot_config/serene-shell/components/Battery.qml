import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Services.UPower
import Quickshell.Widgets

import qs.styles
import qs.services

Rectangle {
    id: root
    implicitWidth: rowRoot.implicitWidth + Metrics.spacingM
    implicitHeight: rowRoot.implicitHeight + Metrics.spacingXs
    color: Colors.md3.on_primary
    radius: Metrics.radiusL
    clip: true

    property UPowerDevice battery: UPower.displayDevice
    property bool onBattery: UPower.onBattery
    readonly property string timeToEmpty: battery.state != UPowerDeviceState.Charging ? Utils.formatSeconds(battery.timeToEmpty) : ""
    readonly property string timeToFull: battery.state != UPowerDeviceState.Discharging ? Utils.formatSeconds(battery.timeToFull) : ""
    readonly property string batteryState: battery.state == UPowerDeviceState.FullyCharged ? "Full" : timeToEmpty.length > 0 ? timeToEmpty : timeToFull
    readonly property int percentage: Math.round(battery.percentage * 100)

    readonly property string levelIconName: {
        if (percentage >= 90) return "full"
        if (percentage >= 60) return "good"
        if (percentage >= 30) return "low"
        if (percentage >= 15) return "caution"
        return "empty"
    }

    readonly property string stateIconName: {
        switch (battery.state) {
            case UPowerDeviceState.Charging: return `battery-${levelIconName}-charging-symbolic`
            case UPowerDeviceState.FullyCharged: return "battery-full-charged-symbolic"
            case UPowerDeviceState.PendingCharge: return `battery-${levelIconName}-symbolic`
            case UPowerDeviceState.PendingDischarge: return `battery-${levelIconName}-symbolic`
            default: return ""
        }
    }

    Row {
        id: rowRoot
        anchors.centerIn: parent
        spacing: Metrics.spacingXs

        Item {
            id: iconContainer
            implicitWidth: Metrics.iconS
            implicitHeight: Metrics.iconS
            anchors.verticalCenter: parent.verticalCenter

            IconImage {
                id: batteryIcon
                anchors.fill: parent
                source: Quickshell.iconPath(stateIconName, true)
                visible: false
            }

            MultiEffect {
                anchors.fill: batteryIcon
                source: batteryIcon
                colorization: 1.0
                colorizationColor: Colors.md3.primary
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: `${percentage}%`
            color: Colors.md3.on_surface
            font.pixelSize: Metrics.fontS
            font.bold: true
        }
    }
}