# LCARS Style Guide

> The single source of truth for how the shell *looks and moves*.
> Every QML component reads its values from `shell/LcarsStyle.qml` — if you
> want to change the look, change the tokens there, not individual files.
> This document also doubles as the design rationale section of the report.

## 1. Principles

1. **LCARS is the interface, not a skin.** No desktop-wallpaper-with-icons.
   Every element — bars, panels, buttons, numbers, animations — is drawn in
   the LCARS language.
2. **Flat and bold.** Solid color fills, thick shapes, high contrast on
   near-black. No gradients, no drop shadows, no 3D bevels, no transparency
   fades (classic LCARS is brutally flat).
3. **Geometry over decoration.** Layout is built from large rounded
   rectangles, long horizontal/vertical bars, and the asymmetric "elbow".
4. **Numbers are heroes.** Status data is shown as big, readable numerals —
   a control panel, not a magazine layout.
5. **Touch-friendly.** Buttons are large (≥ 44 px), with clear pressed states.

## 2. Color

Palette (TNG-era LCARS on near-black). All values live in `LcarsStyle.qml`.

| Token | Hex | Use |
|---|---|---|
| `background` | `#000000` | full-screen canvas |
| `panelDark` | `#10141C` | quiet panel bodies |
| `orange` | `#FFB800` | **primary** — main bars, active states, key buttons |
| `teal` | `#33A1C9` | secondary actions, data bars |
| `cyan` | `#5FD4EE` | tertiary / information accents |
| `red` | `#CC3B3B` | destructive / alerts / power |
| `yellow` | `#FFD84D` | warnings, highlights |
| `purple` | `#C07BDB` | system / utilities |
| `green` | `#7ED37E` | ok / connected states |
| `fg` | `#FFC865` | main text (warm orange) |
| `fgDim` | `#8A6E2F` | secondary text |
| `white` | `#FFFFFF` | rare emphasis only |

Rules: one dominant color per functional area (e.g. nav = orange, network =
cyan), text on colored fills is near-black (`#000`), text on black is `fg`.
Never use more than 3 accent colors on one screen.

## 3. Typography

- **Primary font: Antonio** (Google Fonts, SIL OFL) — condensed, geometric,
  reads like LCARS. Installed by `scripts/setup-fedora.sh`.
- Fallbacks: `"DejaVu Sans Condensed"`, `sans-serif`.
- Style: **bold, uppercase, wide letter-spacing** (3–6 px). No italics, no
  serifs, no mixed case for labels.
- Sizes (`LcarsStyle`): small 14 / medium 20 / large 34 / huge 56.
- Numerals: same font, tabular feel — pad to fixed widths in readouts so
  numbers don't jitter.

## 4. Shape language

- **Radius scale** (`LcarsStyle.radius` = 24, `radiusSmall` = 10). Panels use
  big radii; buttons and pips use small ones.
- **Elbow** (`LcarsElbow.qml`): the iconic shape — a vertical bar that turns
  into a horizontal bar with one *outer* rounded corner and a sharp inner
  corner. Use for section dividers, background art, and page headers.
- **Thick borders**: 2 px outlines on panels; active controls get a filled
  orange treatment instead of a border.
- **Bars**: full-width strips (top master bar, bottom status strip) are the
  skeleton of the layout. Keep them thin (≤ 64 px).

## 5. Layout grammar

```
┌─────────────────────────────────────────────────────────────┐
│ MASTER BAR (top): title · pager · clock          ← always   │
├─────────┬───────────────────────────────────────────────────┤
│ NAV     │                                                 │
│ (left)  │   CONTENT (windows / apps)                       │
│         │                                                 │
├─────────┴───────────────────────────────────────────────────┤
│ STATUS STRIP (bottom): cpu · mem · up · net · vol           │
└─────────────────────────────────────────────────────────────┘
```

- The master bar and status strip are permanent.
- Nav column is the only place for navigation; every "screen" (launcher,
  files, network, system) opens from it as an overlay/panel.
- Overlays are centered floating panels with an orange border and a title
  row — the "computer display" convention.

## 6. Motion

- **Durations:** 150–250 ms for control feedback; 250–400 ms for panel
  opens/closes. Snappy, not floaty.
- **Easing:** ease-out for entrances, ease-in-out for loops. Tokens live in
  `LcarsStyle.animDuration`.
- **Language:**
  - Buttons: instant color shift + slight brighten on press (no bounce).
  - Panels: slide + fade in from the edge they belong to.
  - Status numbers: brief "refresh" blink when the value changes (a 100 ms
    color pulse to `white` → back).
  - Indicators: slow 1–2 s pulsing opacity for "active scanning" states.
- Implement with QML `Behavior`/`NumberAnimation`/`ColorAnimation`; keep the
  VM-friendly rule: *if it's not visible in VirtualBox at 30 fps, cut it*.

## 7. What NOT to do

- No bitmap icons — use text labels + shapes (LCARS has no icon set).
- No wallpaper photography — the background is *drawn* panels on black.
- No rounded corners smaller than `radiusSmall`, no sharp 90° panel corners
  in the chrome (the screen edge is the only right angle).
- No shadows, glows, or gradients.
- No lowercase, no italics.
- No clutter: one idea per panel, lots of black space.
