import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs.services
import qs.styles

WrapperItem {
    id: root

    readonly property var profiles: [
        { 
            profile: PowerProfile.PowerSaver,  
            icon: "image://icon/power-profile-power-saver-symbolic", 
            bg: Colors.md3.secondary_container, 
            fg: Colors.md3.on_secondary_container 
        },
        { 
            profile: PowerProfile.Balanced,    
            icon: "image://icon/power-profile-balanced-symbolic",    
            bg: Colors.md3.surface_container_high, 
            fg: Colors.md3.on_surface_variant 
        },
        { 
            profile: PowerProfile.Performance, 
            icon: "image://icon/power-profile-performance-symbolic", 
            bg: Colors.md3.primary_container,   
            fg: Colors.md3.on_primary_container 
        }
    ]

    readonly property int currentIndex: {
        const i = profiles.findIndex(p => p.profile === PowerProfiles.profile)
        return i >= 0 ? i : 1
    }

    function isAvailable(profile) {
        return profile !== PowerProfile.Performance || PowerProfiles.hasPerformanceProfile
    }

    function cycle() {
        for (let n = 1; n <= profiles.length; n++) {
            const next = profiles[(currentIndex + n) % profiles.length]
            if (isAvailable(next.profile)) {
                PowerProfiles.profile = next.profile
                return
            }
        }
    }

    Rectangle {
        id: button

        implicitWidth: Metrics.iconM
        implicitHeight: Metrics.iconM
        radius: implicitHeight / 2

        color: root.profiles[root.currentIndex].bg
        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: root.profiles[root.currentIndex].fg
            opacity: mouse.containsMouse ? 0.08 : 0
            Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        StackLayout {
            anchors.centerIn: parent
            currentIndex: root.currentIndex

            Repeater {
                model: root.profiles

                delegate: StyledIcon {
                    required property var modelData
                    source: modelData.icon
                    color: modelData.fg
                    size: Metrics.iconS
                }
            }
        }

        MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.cycle()
        }
    }
}