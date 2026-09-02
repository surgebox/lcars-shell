// LcarsElbow — the iconic LCARS "elbow": a vertical bar that turns
// into a horizontal bar, with ONE rounded outer corner and a sharp
// inner corner. This shape is LCARS shorthand; use it for section
// dividers, background art, and page headers.
//
//   ┌──────────────────────────┐
//   │▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│  ← horizontal bar (height = r)
//   └──┐                       │
//      │▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒│
//      │                       │
//      │                       │
//      └───────────────────────┘
import QtQuick
import QtQuick.Shapes

Shape {
    id: elbow

    property color color: LcarsStyle.orange
    // corner radius as a fraction of the smaller side
    property real curve: 0.22

    readonly property real r: Math.max(1, Math.min(width, height) * curve)

    // antialiasing off is fine for large shapes; on for crisp edges
    antialiasing: true

    ShapePath {
        fillColor: elbow.color
        strokeColor: "transparent"
        joinStyle: ShapePath.MiterJoin

        startX: 0
        startY: elbow.height

        // up the left edge
        PathLine { x: 0; y: elbow.r }
        // rounded outer corner (quarter circle, center at (r, r))
        PathArc { x: elbow.r; y: 0; radiusX: elbow.r; radiusY: elbow.r }
        // across the top
        PathLine { x: elbow.width; y: 0 }
        // down the right edge to the inner corner
        PathLine { x: elbow.width; y: elbow.r }
        // back left along the bottom of the horizontal bar
        PathLine { x: elbow.r; y: elbow.r }
        // down the right edge of the vertical bar
        PathLine { x: elbow.r; y: elbow.height }
        // close along the bottom
        PathLine { x: 0; y: elbow.height }
    }

    // Stretch ideas: a `direction` property (rotate the elbow to point
    // left/up/down), and an `outline` variant rendered with two paths.
}
