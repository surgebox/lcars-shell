// LcarsStyle — the single source of truth for the LCARS look.
// Every component reads colors/fonts/metrics from here, so changing
// the style means changing THIS file, not individual QML files.
// See docs/STYLE.md for the design rationale.
pragma Singleton
import QtQuick

QtObject {
    // ---- Palette (TNG-era LCARS on near-black) ----
    readonly property color background:     "#000000"  // full-screen canvas
    readonly property color panelDark:      "#10141C"  // quiet panel bodies
    readonly property color orange:         "#FFB800"  // PRIMARY accent
    readonly property color teal:           "#33A1C9"  // secondary actions
    readonly property color cyan:           "#5FD4EE"  // information
    readonly property color red:            "#CC3B3B"  // power / alerts
    readonly property color yellow:         "#FFD84D"  // warnings
    readonly property color purple:         "#C07BDB"  // system
    readonly property color green:          "#7ED37E"  // ok / connected
    readonly property color fg:             "#FFC865"  // main text
    readonly property color fgDim:          "#8A6E2F"  // secondary text
    readonly property color white:          "#FFFFFF"

    // ---- Typography ----
    readonly property string fontFamily: "Antonio"   // free Google font, installed by setup script
    readonly property int fontSizeSmall:   14
    readonly property int fontSizeMedium:  20
    readonly property int fontSizeLarge:   34
    readonly property int fontSizeHuge:    56

    // ---- Metrics ----
    readonly property int barHeight:        64   // top master bar
    readonly property int statusBarHeight:  48   // bottom status strip
    readonly property int navWidth:         150  // left navigation column
    readonly property int radius:           24   // large LCARS rounding
    readonly property int radiusSmall:      10   // buttons, pips
    readonly property int margin:           16
    readonly property int buttonHeight:     48
    readonly property int animDuration:     200  // ms, control feedback

    // ---- Motion ----
    readonly property int animDurationPanel: 300 // ms, panel open/close
}
