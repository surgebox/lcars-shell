// ============================================================
//  LCARS SHELL — entry point
//  Target: Quickshell 0.2.1 (the Fedora-packaged version)
//  Launch: quickshell -p /path/to/lcars-shell/shell/shell.qml
//  Docs:   https://quickshell.org/docs/v0.2.1/
// ============================================================
import QtQuick
import QtQuick.Layouts
import Quickshell

ShellRoot {
    id: root

    // Hot-reload QML edits as you save (dev mode)
    settings.watchFiles: true

    // ---- Full-screen LCARS background ----
    // Quickshell 0.2.1 has no ShellScreen window type; the background is a
    // full-screen PanelWindow with `aboveWindows: false`, which renders on
    // the layer-shell layer BELOW normal windows.
    PanelWindow {
        id: lcarsBackground
        anchors { left: true; right: true; top: true; bottom: true; }
        aboveWindows: false
        color: LcarsStyle.background

        // deep-space canvas (covers the window if `color` is unsupported)
        Rectangle {
            anchors.fill: parent
            color: LcarsStyle.background
        }

        // decorative background art — purely cosmetic, sits behind windows
        LcarsElbow {
            anchors.top: parent.top
            anchors.right: parent.right
            width: 560
            height: 220
            color: LcarsStyle.teal
            opacity: 0.35
        }

        LcarsElbow {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: 300
            height: 420
            color: LcarsStyle.orange
            opacity: 0.22
        }

        LcarsPanel {
            anchors.centerIn: parent
            width: 460
            height: 300
            fill: LcarsStyle.panelDark
            outline: LcarsStyle.orange

            Text {
                anchors.centerIn: parent
                text: "LCARS // SHELL v0.1"
                color: LcarsStyle.fgDim
                font.family: LcarsStyle.fontFamily
                font.pixelSize: LcarsStyle.fontSizeMedium
                font.bold: true
                font.letterSpacing: 6
            }
        }
    }

    // ---- Top master bar ----
    PanelWindow {
        id: topBar
        anchors { left: true; right: true; top: true; }
        implicitHeight: LcarsStyle.barHeight
        color: LcarsStyle.background

        TopBar {
            anchors.fill: parent
        }
    }

    // ---- Bottom status strip ----
    PanelWindow {
        id: statusBar
        anchors { left: true; right: true; bottom: true; }
        implicitHeight: LcarsStyle.statusBarHeight
        color: LcarsStyle.background

        StatusBar {
            anchors.fill: parent
        }
    }

    // ---- Left navigation column ----
    PanelWindow {
        id: navPanel
        anchors { left: true; top: true; bottom: true; }
        implicitWidth: LcarsStyle.navWidth
        color: LcarsStyle.background

        NavPanel {
            id: nav
            anchors.fill: parent
            onOpenLauncher: launcher.visible = !launcher.visible
        }
    }

    // ---- Launcher overlay ----
    Launcher {
        id: launcher
    }
}
