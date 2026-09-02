// NavPanel — the left LCARS navigation column.
// Buttons open the launcher now; file viewer / network / system panels
// are next milestones (see docs/PHASES.md).
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Item {
    id: root

    signal openLauncher()

    Rectangle {
        anchors.fill: parent
        color: LcarsStyle.background
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        LcarsLabel {
            text: "MENU"
            size: LcarsStyle.fontSizeSmall
            ink: LcarsStyle.fgDim
        }

        LcarsButton {
            label: "APPLICATIONS"
            Layout.fillWidth: true
            onClicked: root.openLauncher()
        }

        LcarsButton {
            label: "FILES"
            Layout.fillWidth: true
            color: LcarsStyle.teal
            onClicked: console.log("TODO: file viewer (Quickshell.Io.FileView)")
        }

        LcarsButton {
            label: "NETWORK"
            Layout.fillWidth: true
            color: LcarsStyle.cyan
            onClicked: console.log("TODO: network panel (Quickshell.Networking)")
        }

        LcarsButton {
            label: "SYSTEM"
            Layout.fillWidth: true
            color: LcarsStyle.purple
            onClicked: console.log("TODO: system panel")
        }

        Item {
            Layout.fillHeight: true
        }

        LcarsButton {
            label: "POWER"
            Layout.fillWidth: true
            color: LcarsStyle.red
            onClicked: Hyprland.dispatch("exit")
        }
    }
}
