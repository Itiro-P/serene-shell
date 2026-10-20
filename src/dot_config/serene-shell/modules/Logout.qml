import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick.Effects

import qs.services
import qs.styles

Scope {
    id: root

    property real progress: States.logoutOpen ? 1 : 0

    Behavior on progress {
        NumberAnimation {
            duration: 180
            easing.type: States.logoutOpen ? Easing.OutBack : Easing.InCubic
        }
    }

    LazyLoader {
        active: States.logoutOpen || root.progress > 0

        PanelWindow {
            id: logoutWindow
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            WlrLayershell.layer: WlrLayer.Overlay
            color: "transparent"
            aboveWindows: true
            focusable: true
            exclusionMode: ExclusionMode.Ignore

            Shortcut {
                sequence: "Escape"
                onActivated: States.clear()
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.5 * root.progress)

                MouseArea {
                    anchors.fill: parent
                    onClicked: States.clear()
                }
            }

            Rectangle {
                id: content
                radius: Metrics.radiusL * 2
                anchors.centerIn: parent
                color: Colors.md3.surface

                implicitHeight: contentColumn.implicitHeight + Metrics.spacingM * 2
                implicitWidth: contentColumn.implicitWidth + Metrics.spacingM * 2

                width: implicitWidth
                height: implicitHeight

                opacity: root.progress
                scale: 0.9 + (0.1 * root.progress)

                component ActionButton: Button {
                    id: btn
                    property string iconName: ""
                    implicitWidth: Metrics.buttonHeight * 4
                    implicitHeight: Metrics.buttonHeight * 4

                    scale: btn.activeFocus || btn.hovered ? 1.08 : 1.0

                    Behavior on scale {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.OutCubic
                        }
                    }

                    background: Rectangle {
                        radius: Metrics.radiusFull
                        color: btn.activeFocus || btn.hovered ? Colors.md3.primary : Colors.md3.primary_fixed
                        border.width: btn.activeFocus ? 2 : 0
                        border.color: Colors.md3.on_primary

                        Behavior on color {
                            ColorAnimation { duration: 120 }
                        }
                    }

                    contentItem: Item {
                        IconImage {
                            id: icon
                            width: Metrics.iconL * 4
                            height: Metrics.iconL * 4
                            anchors.centerIn: parent
                            source: Quickshell.iconPath(iconName)
                            visible: false
                        }

                        MultiEffect {
                            anchors.fill: icon
                            source: icon
                            colorization: 1.0
                            colorizationColor: btn.activeFocus || btn.hovered ? Colors.md3.on_primary : Colors.md3.on_primary_fixed

                            Behavior on colorizationColor {
                                ColorAnimation { duration: 120 }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {}
                }

                ColumnLayout {
                    id: contentColumn
                    anchors.centerIn: parent
                    spacing: Metrics.spacingXl

                    RowLayout {
                        spacing: Metrics.spacingXl

                        ActionButton {
                            id: btnLock
                            iconName: "system-lock-screen-symbolic"
                            onClicked: {
                                LogoutCommands.lock()
                                States.clear()
                            }
                            Keys.onReturnPressed: {
                                LogoutCommands.lock()
                                States.clear()
                            }
                            KeyNavigation.right: btnLogout
                            KeyNavigation.down: btnHibernate
                        }
                        ActionButton {
                            id: btnLogout
                            iconName: "system-log-out-symbolic"
                            onClicked: {
                                LogoutCommands.logout()
                                States.clear()
                            }
                            Keys.onReturnPressed: {
                                LogoutCommands.logout()
                                States.clear()
                            }
                            KeyNavigation.left: btnLock
                            KeyNavigation.right: btnSuspend
                            KeyNavigation.down: btnShutdown
                        }
                        ActionButton {
                            id: btnSuspend
                            iconName: "system-suspend-symbolic"
                            onClicked: {
                                LogoutCommands.suspend()
                                States.clear()
                            }
                            Keys.onReturnPressed: {
                                LogoutCommands.suspend()
                                States.clear()
                            }
                            KeyNavigation.left: btnLogout
                            KeyNavigation.down: btnReboot
                        }
                    }

                    RowLayout {
                        spacing: Metrics.spacingXl

                        ActionButton {
                            id: btnHibernate
                            iconName: "system-hibernate-symbolic"
                            onClicked: {
                                LogoutCommands.hibernate()
                                States.clear()
                            }
                            Keys.onReturnPressed: {
                                LogoutCommands.hibernate()
                                States.clear()
                            }
                            KeyNavigation.right: btnShutdown
                            KeyNavigation.up: btnLock
                        }
                        ActionButton {
                            id: btnShutdown
                            iconName: "system-shutdown-symbolic"
                            onClicked: {
                                LogoutCommands.poweroff()
                                States.clear()
                            }
                            Keys.onReturnPressed: {
                                LogoutCommands.poweroff()
                                States.clear()
                            }
                            KeyNavigation.left: btnHibernate
                            KeyNavigation.right: btnReboot
                            KeyNavigation.up: btnLogout
                        }
                        ActionButton {
                            id: btnReboot
                            iconName: "system-reboot-symbolic"
                            onClicked: {
                                LogoutCommands.reboot()
                                States.clear()
                            }
                            Keys.onReturnPressed: {
                                LogoutCommands.reboot()
                                States.clear()
                            }
                            KeyNavigation.left: btnShutdown
                            KeyNavigation.up: btnSuspend
                        }
                    }
                }
            }
            Component.onCompleted: btnLock.forceActiveFocus()
        }
    }
}