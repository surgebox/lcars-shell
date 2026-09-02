// LcarsPanel — a rounded LCARS panel.
// Thin wrapper over Rectangle so it can be used anywhere a Rectangle
// is expected. Asymmetric "elbow" corners live in LcarsElbow.qml.
import QtQuick

Rectangle {
    id: panel

    property color fill: LcarsStyle.panelDark
    property color outline: LcarsStyle.orange
    property int cornerRadius: LcarsStyle.radius
    property bool drawBorder: true

    color: fill
    radius: cornerRadius
    border.width: drawBorder ? 2 : 0
    border.color: outline
}
