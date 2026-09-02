// LcarsLabel — LCARS-styled text (bold, uppercase-ish, letter-spaced).
// A thin wrapper over Text so every readout/label looks the same.
import QtQuick

Text {
    property color ink: LcarsStyle.fg
    property int size: LcarsStyle.fontSizeMedium
    property int spacing: 3

    color: ink
    font.family: LcarsStyle.fontFamily
    font.pixelSize: size
    font.bold: true
    font.letterSpacing: spacing
    verticalAlignment: Text.AlignVCenter
}
