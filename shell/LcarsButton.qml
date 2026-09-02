// LcarsButton — a large, touch-friendly LCARS button.
// Filled rounded rectangle with bold uppercase text; the fill
// brightens while pressed. Emits `clicked`.
import QtQuick

Item {
    id: root

    property string label: ""
    property color color: LcarsStyle.orange
    property color textColor: LcarsStyle.background
    property int cornerRadius: LcarsStyle.radiusSmall
    property alias fontPixelSize: label.font.pixelSize
    signal clicked()

    implicitWidth: 180
    implicitHeight: LcarsStyle.buttonHeight

    Rectangle {
        id: background
        anchors.fill: parent
        radius: root.cornerRadius
        color: root.color

        Behavior on color {
            ColorAnimation { duration: LcarsStyle.animDuration }
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: root.label
            color: root.textColor
            font.family: LcarsStyle.fontFamily
            font.pixelSize: LcarsStyle.fontSizeMedium
            font.bold: true
            font.letterSpacing: 3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    // pressed-state visual
    states: State {
        name: "pressed"
        when: mouse.pressed
        PropertyChanges { target: background; color: Qt.lighter(root.color, 1.35) }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
