// TopBar — the LCARS master bar: system title, workspace pager, clock.
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    // orange accent strip along the bottom edge (LCARS signature)
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: 8
        width: parent.width * 0.55
        color: LcarsStyle.orange
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 24

        LcarsLabel {
            text: "FEDORA // LCARS"
            size: LcarsStyle.fontSizeLarge
            ink: LcarsStyle.orange
            Layout.alignment: Qt.AlignVCenter
        }

        WorkspacePager {
            Layout.alignment: Qt.AlignVCenter
        }

        Item {
            Layout.fillWidth: true
        }

        ClockReadout {
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
