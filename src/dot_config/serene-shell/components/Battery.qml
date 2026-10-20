import Quickshell
import QtQuick
import Quickshell.Services.UPower

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

    // 0, 10, 20 ... 100 (arredonda para baixo para não superestimar a carga)
    readonly property int level: Math.floor(percentage / 10) * 10

    readonly property string stateIconName: {
        switch (battery.state) {
        case UPowerDeviceState.Charging:
            return `battery-level-${level}-charging-symbolic`
        case UPowerDeviceState.FullyCharged:
            return "battery-level-100-charged-symbolic"
        case UPowerDeviceState.PendingCharge:
            return `battery-level-${level}-plugged-in-symbolic`
        case UPowerDeviceState.Discharging:
        case UPowerDeviceState.PendingDischarge:
            return `battery-level-${level}-symbolic`
        case UPowerDeviceState.Empty:
            return "battery-level-0-symbolic"
        default:
            return "abattery-missing-symbolic"
        }
    }

    Row {
        id: rowRoot
        anchors.centerIn: parent
        spacing: Metrics.spacingXs

        StyledIcon {
            size: Metrics.iconS
            source: Quickshell.iconPath(root.stateIconName, true)
            color: Colors.md3.primary
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.percentage + '%'
            color: Colors.md3.on_surface
            font.pixelSize: Metrics.fontM
        }
    }
}