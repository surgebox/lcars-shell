# LCARS Shell

A Star Trek LCARS–inspired graphical shell for **Fedora Linux**, built on
**Hyprland** + **Quickshell** (QML). Every pixel of the interface — bars,
panels, buttons, status readouts, launcher, animations — is drawn by our own
QML code, so the LCARS style is the *whole* interface, not a theme on top of
a normal desktop.

```
┌──────────────────────────────────────────────────────────────────────┐
│ FEDORA // LCARS          [ 1 ][ 2 ][ 3 ]        SD 41262.45  14:03:22 │
├──────────────┬───────────────────────────────────────────────────────┤
│ ▓ MENU       │                                                       │
│ [APPLICATIONS]│                                                       │
│ [FILES]      │          (your windows live here)                     │
│ [NETWORK]    │                                                       │
│ [SYSTEM]     │                                                       │
│              │                                                       │
│ [POWER]      │                                                       │
├──────────────┴───────────────────────────────────────────────────────┤
│ CPU 12%   MEM 34%   UP 3h12m                NET --   VOL --          │
└──────────────────────────────────────────────────────────────────────┘
```

## Why this stack

| Piece | Job |
|---|---|
| **Hyprland** | Wayland compositor: draws windows, manages workspaces, animations. Ships with *no* bars or menus, so nothing fights our design. |
| **Quickshell** | The shell: our QML code renders the full-screen background, top bar, status bar, nav panel, launcher and (later) notifications. It talks to Hyprland over its IPC (`Quickshell.Hyprland`) and reads system data (`Quickshell.Io`, `Quickshell.Networking`, `Quickshell.Services.*`). |
| **Fedora** | The base OS. VirtualBox-friendly, and the professor gets a ready-to-import `.ova` appliance at the end. |

## Repo layout

```
lcars-shell/
├── README.md              ← you are here
├── docs/
│   ├── STYLE.md           ← LCARS design guide (colors, fonts, shapes, motion)
│   ├── PHASES.md          ← project plan: phases, roles, risks, delivery
│   └── vm-virtualbox.md   ← VirtualBox setup, autologin, .ova export
├── hypr/
│   └── hyprland.conf      ← compositor config (launches the shell)
├── scripts/
│   └── setup-fedora.sh    ← one-shot Fedora installer (COPRs + packages + font)
└── shell/                 ← the whole LCARS UI, in QML
    ├── shell.qml          ← entry point (ShellRoot)
    ├── qmldir             ← registers LcarsStyle as a singleton
    ├── LcarsStyle.qml     ← THE design tokens: colors, fonts, metrics
    ├── LcarsPanel.qml     ← rounded LCARS panel
    ├── LcarsElbow.qml     ← the classic asymmetric "elbow" shape
    ├── LcarsButton.qml    ← touch-friendly LCARS button (hover/press)
    ├── LcarsLabel.qml     ← LCARS-styled text
    ├── TopBar.qml         ← master bar: title, workspaces, clock
    ├── StatusBar.qml      ← bottom strip: CPU / MEM / uptime
    ├── NavPanel.qml       ← left navigation column
    ├── WorkspacePager.qml ← live Hyprland workspace switcher
    ├── ClockReadout.qml   ← clock + stardate
    ├── SystemReadout.qml  ← CPU / RAM / uptime from /proc
    └── Launcher.qml       ← app launcher overlay
```

## Quick start (on your Fedora machine / VM)

```bash
# 1. From this repo's root:
bash scripts/setup-fedora.sh          # Hyprland (COPR) + Quickshell 0.2.1 (official Fedora) + apps + font

# 2. Start a session (from a TTY or your display manager):
Hyprland
```

The shell starts automatically (`exec-once` in `hypr/hyprland.conf`, which the
script installs to `~/.config/hypr/hyprland.conf`). If your repo lives
somewhere other than `~/lcars-shell`, fix the path in that file.

## Development loop (this is the fun part)

Quickshell **hot-reloads QML files as you save them** (`settings.watchFiles: true`
in `shell.qml`). So:

1. Edit any file in `shell/`
2. Save — the running shell reloads instantly
3. Screenshot / repeat

No compile step, no restart, no command line needed for iteration.

## Troubleshooting

| Symptom | Fix |
|---|---|
| `quickshell` fails to start: `symbol lookup error: ... Qt_6.11_PRIVATE_API` | Both Quickshell **COPR** builds for Fedora 44 are built against a Qt newer than the repos ship. The setup script installs Fedora's **official `quickshell` 0.2.1** instead (COPRs disabled for that one install) and versionlocks it. Manual fix: `sudo dnf --disablerepo='copr*' downgrade quickshell`. |
| `LcarsPanel is not a type` / `LcarsStyle is not defined` | `shell/qmldir` must declare **every** QML file — in Qt 6, when a `qmldir` exists, loose `.qml` files are not auto-registered. The repo's `qmldir` does this; re-clone if it's missing. |
| Hyprland won't start in VirtualBox | See `docs/vm-virtualbox.md` — software rendering env vars + display-manager setup. |
| Workspace pager / CPU numbers don't update | The shell targets **quickshell 0.2.1** (Fedora's package). If you run another version, check property names against [the 0.2.1 docs](https://quickshell.org/docs/v0.2.1/) and adjust — the structure stays the same. |
| Windows overlap the bars | Quickshell `PanelWindow`s should reserve space by default; if not, check the `exclusionMode` property in the docs. |

## Status

Phase 1/2 starter: background + top bar + status bar + nav panel + workspace
pager + launcher. Next up: notifications, file viewer, network panel, media
OSD — see `docs/PHASES.md`.

## Credits / related work

- [Quickshell](https://quickshell.org) — the toolkit (MIT-ish / LGPL, see repo)
- [lcarsde](https://github.com/lcarsde/lcarsde) — an earlier full LCARS desktop environment (study material)
- [caelestia shell](https://github.com/caelestia-dots/shell) — a polished Quickshell config (study material)
- [Quickshell examples](https://github.com/quickshell-mirror/quickshell-examples) — official examples
- Antonio font by Santiago Orozco — [SIL OFL](https://github.com/google/fonts/tree/main/ofl/antonio), very LCARS
- LCARS is a design language from *Star Trek* (Paramount). This is a fan-made,
  educational project: "LCARS-inspired", not affiliated with or endorsed by
  Paramount.
