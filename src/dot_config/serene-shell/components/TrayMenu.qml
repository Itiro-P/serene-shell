import Quickshell
import Quickshell.Widgets
import QtQuick

import qs.styles

PopupWindow {
    id: root

    required property QtObject rootBar

    property var menuHandle: null
    property var stack: []   // pilha de QsMenuEntry (submenus abertos)

    readonly property var currentMenu: stack.length > 0 ? stack[stack.length - 1] : menuHandle

    readonly property int padding: Metrics.spacingXs
    readonly property int rowHeight: Metrics.iconM + Metrics.spacingXs * 2

    color: "transparent"
    grabFocus: true

    implicitWidth: 240
    implicitHeight: content.implicitHeight + padding * 2

    anchor.window: rootBar
    anchor.edges: Edges.Bottom | Edges.Left
    anchor.gravity: Edges.Bottom | Edges.Right
    anchor.adjustment: PopupAdjustment.Slide | PopupAdjustment.Flip

    function openFor(item, handle) {
        const p = item.mapToItem(null, 0, 0)
        anchor.rect = Qt.rect(p.x, p.y, item.width, item.height)
        stack = []
        menuHandle = handle
        visible = true
    }

    onVisibleChanged: if (!visible) stack = []

    QsMenuOpener {
        id: opener
        menu: root.currentMenu
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.md3.surface_container
        radius: Metrics.radiusL
        border.width: 1
        border.color: Colors.md3.outline_variant

        Behavior on color { ColorAnimation { duration: 150 } }

        Column {
            id: content
            x: root.padding
            y: root.padding
            width: parent.width - root.padding * 2

            // Linha "Voltar" (só dentro de submenus)
            Rectangle {
                visible: root.stack.length > 0
                width: content.width
                height: visible ? root.rowHeight : 0
                radius: Metrics.radiusL
                color: backMouse.containsMouse
                    ? Qt.alpha(Colors.md3.on_surface, 0.08) : "transparent"

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    x: Metrics.spacingM
                    text: "‹  Voltar"
                    color: Colors.md3.on_surface
                    font.pixelSize: Metrics.fontS
                }

                MouseArea {
                    id: backMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.stack = root.stack.slice(0, -1)
                }
            }

            Repeater {
                model: opener.children

                delegate: Item {
                    id: entry
                    required property QsMenuEntry modelData

                    width: content.width
                    height: modelData.isSeparator ? 1 + Metrics.spacingXs * 2 : root.rowHeight

                    // Separador
                    Rectangle {
                        visible: entry.modelData.isSeparator
                        anchors.verticalCenter: parent.verticalCenter
                        x: Metrics.spacingM
                        width: parent.width - Metrics.spacingM * 2
                        height: 1
                        color: Colors.md3.outline_variant
                    }

                    // Item normal
                    Rectangle {
                        visible: !entry.modelData.isSeparator
                        anchors.fill: parent
                        radius: Metrics.radiusL
                        opacity: entry.modelData.enabled ? 1 : 0.38
                        color: itemMouse.containsMouse && entry.modelData.enabled
                            ? Qt.alpha(Colors.md3.on_surface, 0.08) : "transparent"

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            x: Metrics.spacingM
                            width: parent.width - Metrics.spacingM * 2
                            spacing: Metrics.spacingXs

                            // Indicador de checkbox / radio
                            Text {
                                visible: entry.modelData.buttonType !== QsMenuButtonType.None
                                width: visible ? Metrics.iconS : 0
                                anchors.verticalCenter: parent.verticalCenter
                                horizontalAlignment: Text.AlignHCenter
                                color: Colors.md3.primary
                                font.pixelSize: Metrics.fontS
                                text: entry.modelData.checkState === Qt.Unchecked ? ""
                                    : entry.modelData.buttonType === QsMenuButtonType.RadioButton ? "●"
                                    : "✓"
                            }

                            // Ícone do item (colorido pelo próprio app)
                            IconImage {
                                visible: entry.modelData.icon !== ""
                                width: visible ? Metrics.iconS : 0
                                height: Metrics.iconS
                                anchors.verticalCenter: parent.verticalCenter
                                source: entry.modelData.icon
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                width: parent.width
                                       - (entry.modelData.hasChildren ? Metrics.iconS : 0)
                                elide: Text.ElideRight
                                text: entry.modelData.text
                                color: Colors.md3.on_surface
                                font.pixelSize: Metrics.fontS
                            }

                            // Seta de submenu
                            Text {
                                visible: entry.modelData.hasChildren
                                anchors.verticalCenter: parent.verticalCenter
                                text: "›"
                                color: Colors.md3.on_surface_variant
                                font.pixelSize: Metrics.fontS
                            }
                        }

                        MouseArea {
                            id: itemMouse
                            anchors.fill: parent
                            enabled: entry.modelData.enabled
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (entry.modelData.hasChildren) {
                                    root.stack = root.stack.concat([entry.modelData])
                                } else {
                                    entry.modelData.triggered()
                                    root.visible = false
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}