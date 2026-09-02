// Launcher — LCARS application launcher overlay.
// A floating window toggled from the nav panel. Apps launch through
// Hyprland.dispatch("exec", ...) so they join the session normally.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

FloatingWindow {
    id: launcher

    visible: false
    implicitWidth: 780
    implicitHeight: 480
    color: LcarsStyle.background

    LcarsPanel {
        anchors.fill: parent
        anchors.margins: 10
        fill: LcarsStyle.panelDark
        outline: LcarsStyle.orange

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 18

            LcarsLabel {
                text: "APPLICATIONS"
                size: LcarsStyle.fontSizeLarge
                ink: LcarsStyle.orange
            }

            GridLayout {
                columns: 2
                columnSpacing: 18
                rowSpacing: 18
                Layout.fillWidth: true
                Layout.fillHeight: true

                LcarsButton {
                    label: "WEB // FIREFOX"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    onClicked: launch("firefox")
                }

                LcarsButton {
                    label: "TERMINAL // KITTY"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    color: LcarsStyle.teal
                    onClicked: launch("kitty")
                }

                LcarsButton {
                    label: "FILES // NAUTILUS"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    color: LcarsStyle.cyan
                    onClicked: launch("nautilus")
                }

                LcarsButton {
                    label: "CLOSE"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 64
                    color: LcarsStyle.red
                    onClicked: launcher.visible = false
                }
            }

            LcarsLabel {
                text: "MORE APPS COMING IN PHASE 3 // FILE VIEWER · NETWORK · MEDIA"
                size: LcarsStyle.fontSizeSmall
                ink: LcarsStyle.fgDim
            }
        }
    }

    function launch(app) {
        Hyprland.dispatch("exec", app);
        launcher.visible = false;
    }
}
