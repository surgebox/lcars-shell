// StatusBar — the bottom strip: live system readouts (CPU, RAM, uptime)
// plus placeholders for network/volume (see TODO below).
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    SystemReadout {
        id: sys
    }

    // teal accent strip along the top edge
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        height: 6
        width: parent.width * 0.4
        color: LcarsStyle.teal
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 28

        LcarsLabel { text: "CPU " + sys.cpuPercent + "%" }
        LcarsLabel { text: "MEM " + sys.ramPercent + "%  " + sys.ramText }
        LcarsLabel { text: "UP " + sys.uptimeText }

        Item { Layout.fillWidth: true }

        // TODO: real network readout via Quickshell.Networking
        //   https://quickshell.org/docs/v0.3.0/types/Quickshell.Networking/Networking
        LcarsLabel {
            text: "NET --"
            ink: LcarsStyle.fgDim
        }

        // TODO: real volume readout via Quickshell.Services.Pipewire
        //   https://quickshell.org/docs/v0.3.0/types/Quickshell.Services.Pipewire/Pipewire
        LcarsLabel {
            text: "VOL --"
            ink: LcarsStyle.fgDim
        }

        LcarsLabel {
            text: "TRN // SYS-01"
            ink: LcarsStyle.fgDim
        }
    }
}
