# Project Plan — LCARS Shell for Fedora (Hyprland + Quickshell)

> Working document for the team. Adjust phases to your semester schedule.
> Everything here is written so a newcomer can pick it up.

## 1. Mission

Deliver a **graphical interface for Fedora** whose entire visual language is
**Star Trek LCARS** — layout, controls, status displays, navigation,
animations — and package it so the professor can boot it in **VirtualBox**
with almost no command line: *double-click → import → boot → LCARS*.

## 2. The stack (why this is the right bet)

- **Hyprland** — Wayland compositor. Customizable, modern, ships with no
  chrome of its own (nothing fights our design). Fedora community packaging
  via COPR.
- **Quickshell** — the shell toolkit. Our entire UI is QML: full control of
  every pixel, live hot-reload while developing, first-party integrations
  for Hyprland workspaces, networking, notifications, audio, system tray.
- **Fedora** — stable base, good VirtualBox support, free.

Alternative considered: theming GNOME/KDE. Rejected: a themed GNOME is still
a GNOME desktop with an LCARS wallpaper — the assignment demands the style
*throughout the application*. With Quickshell the style *is* the application.

## 3. MVP definition (the professor demo)

Boot → auto-login → full-screen LCARS shell:

- [x] Full-screen LCARS background (drawn, not a photo)
- [x] Top master bar: title, workspace pager, clock + stardate
- [x] Bottom status strip: CPU, RAM, uptime
- [x] Left nav column with LCARS buttons
- [x] Launcher overlay that starts real apps (Firefox, terminal, files)
- [ ] Notifications popups (Quickshell.Services.Notifications)
- [ ] File viewer (Quickshell.Io.FileView)
- [ ] Network panel (Quickshell.Networking)
- [ ] Volume/brightness OSD (Quickshell.Services.Pipewire)
- [ ] Auto-login + polished VirtualBox `.ova`

## 4. Phases

| Phase | Goal | Deliverable | Owner role |
|---|---|---|---|
| **0. Plan** | Agree on scope, style, roles; set up GitHub | This doc + STYLE.md + repo | Whole team |
| **1. Proof** | VM boots into Hyprland + Quickshell rendering LCARS | Screenshot: "Hello LCARS" | Infra |
| **2. Shell core** | Bars, clock, workspaces, status numbers | Interactive shell (current state) | Shell lead + Infra |
| **3. Applets** | Launcher (done), notifications, file viewer, network | MVP demo video | Applets + Designer |
| **4. Delivery** | Autologin, animations polish, `.ova` export, report | Professor-ready VM | Whole team |

Each phase ends with a **demo to the group** (2 minutes, no excuses) — this is
how a team of newcomers stays honest.

## 5. Suggested roles (4 people)

1. **Infra** — VirtualBox VM, Hyprland config, setup script, autologin, `.ova`.
2. **Shell/QML lead** — `shell.qml`, `LcarsStyle.qml`, bars, layout; owns
   consistency; reviews everyone's QML.
3. **Applets** — launcher, file viewer, network panel, notifications.
4. **Design/QA** — STYLE.md compliance, screenshots, docs, demo script, report.

Everyone learns basic QML — it is a small language and Quickshell hot-reloads,
so iteration is fast. Pair-program the first QML session.

## 6. Risk register

| Risk | Likelihood | Mitigation |
|---|---|---|
| **Hyprland rendering in VirtualBox** (no GPU Vulkan) | High | Test in the VM in Phase 1 (not at the end). Software rendering via Mesa lavapipe; low resolution; trimmed animations. See `vm-virtualbox.md`. |
| **Quickshell packaging trap** — both quickshell COPR builds for Fedora 44 crash with `Qt_6.11_PRIVATE_API` symbol errors (built against a newer Qt) | High (hit us in Phase 1) | Install Quickshell from the **official Fedora repos** (0.2.1) with COPRs disabled for that package, and versionlock it. The setup script does this; the shell QML targets the 0.2.1 API. |
| Quickshell API changes between versions | Medium | Pin to the Fedora-packaged version; check [docs](https://quickshell.org/docs/) for exact property names; isolate version-specific code. |
| Scope creep (LCARS is a deep rabbit hole) | High | MVP list above is the contract. Stretch goals only after demo works. |
| Team is new to Linux/QML | High | Weekly demos, pair programming, keep components small, hot-reload makes mistakes cheap. |
| LCARS is Paramount IP | Low (educational) | Report states "LCARS-inspired, fan-made, not affiliated"; use free fonts (Antonio, OFL). |

## 7. Delivery to the professor

Primary: **VirtualBox appliance (`.ova`)** — import, boot, done.
Stretch: a custom Fedora ISO (livecd-tools + kickstart) as "future work".

The `.ova` must contain: Fedora + Hyprland + Quickshell + the shell config +
**auto-login** (SDDM autologin or TTY autologin) so booting lands directly in
LCARS. Include a one-page README and a 2-minute demo script.

## 8. Related work (cite these in the report)

- [lcarsde](https://github.com/lcarsde/lcarsde) — full LCARS desktop environment for Linux (now unmaintained) — proof the concept is established.
- [Quickshell](https://quickshell.org) — toolkit + [official examples](https://github.com/quickshell-mirror/quickshell-examples).
- [caelestia shell](https://github.com/caelestia-dots/shell) — real-world Quickshell shell (featured on quickshell.org).
- [Fedora Hyprland install guide](https://discussion.fedoraproject.org/t/tutorial-fedora-43-install-hyprland-from-scratch/168386) — community walkthrough we verified.
