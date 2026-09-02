// WorkspacePager — live Hyprland workspace switcher.
// Renders one LCARS pip per workspace; the active workspace is filled
// orange; clicking switches to that workspace.
//
// API reference (verify against YOUR quickshell version):
//   https://quickshell.org/docs/v0.3.0/types/Quickshell.Hyprland/Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Item {
    id: root

    implicitHeight: 36

    Row {
        id: row
        anchors.fill: parent
        spacing: 8

        Repeater {
            model: Hyprland.workspaces   // ObjectModel<HyprlandWorkspace>

            delegate: Rectangle {
                required property var modelData

                readonly property bool focused: Hyprland.focusedWorkspace !== null
                    && modelData.id === Hyprland.focusedWorkspace.id

                width: 44
                height: 36
                radius: LcarsStyle.radiusSmall
                color: focused ? LcarsStyle.orange : LcarsStyle.panelDark
                border.color: LcarsStyle.orange
                border.width: 1

                Behavior on color {
                    ColorAnimation { duration: LcarsStyle.animDuration }
                }

                Text {
                    anchors.centerIn: parent
                    text: modelData.id
                    color: focused ? LcarsStyle.background : LcarsStyle.orange
                    font.family: LcarsStyle.fontFamily
                    font.pixelSize: LcarsStyle.fontSizeMedium
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace", "" + modelData.id)
                }
            }
        }
    }
}
