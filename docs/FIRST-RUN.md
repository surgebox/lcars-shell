# First Run — from zero to "Hello LCARS"

> The checklist version of the walkthrough. Follow it top to bottom on the
> machine that will run the VM. If something fails, the troubleshooting
> table at the end is sorted by likelihood.

## Step 0 — Decisions (5 minutes, do this with your group)

- [ ] Pick the **one dev rig**: a machine (Windows/Mac/Linux) with
      ~8 GB+ free RAM, VirtualBox installed, and internet. Everyone else
      works on the repo / design / docs until the VM is proven.
- [ ] Create a **GitHub repo** (private is fine) and push this folder.
      See the git commands below. This is how the group shares code, and
      how the VM pulls the files in.

```bash
# from the folder containing lcars-shell/ (or inside it):
cd lcars-shell
git init
git add .
git commit -m "LCARS shell starter kit (Phase 1/2)"
git branch -M main
git remote add origin https://github.com/YOUR_USER/lcars-shell.git
git push -u origin main
```

## Step 1 — Create the VM (30–40 minutes)

1. Download the current **Fedora Workstation ISO** from https://getfedora.org.
2. In VirtualBox: **New** → name it `LCARS` → type *Linux*, version
   *Fedora (64-bit)*.
3. Settings (from `docs/vm-virtualbox.md`):

   | Setting | Value |
   |---|---|
   | Memory | 4096 MB |
   | CPUs | 2–4 |
   | Video memory | **256 MB** (default 16 MB is not enough) |
   | 3D acceleration | **Enabled** (Settings → Display) |
   | Graphics controller | VMSVGA |
   | Disk | 40 GB, dynamic |

4. Start the VM, boot the ISO, and run the Fedora installer. Choose
   **"Install to Hard Drive"** → default partition layout → create a user
   account → reboot.
5. After reboot you land in a normal GNOME desktop. **That's fine** — GNOME
   is our rescue session; the LCARS shell takes over later.

## Step 2 — Install the shell inside the VM (10–20 minutes)

Open a terminal (Super key → "Terminal" or GNOME's console):

```bash
sudo dnf update -y

# pull the project in (substitute your repo URL):
git clone https://github.com/YOUR_USER/lcars-shell.git
cd lcars-shell

# one-shot installer: COPR repos → packages → font → Hyprland config
bash scripts/setup-fedora.sh
```

What the script does, step by step:

1. **Enables the Hyprland COPR** — `lionheartp/Hyprland`. Quickshell is
   deliberately **not** installed from any COPR: both quickshell COPR builds
   for Fedora 44 crash with a Qt private-API symbol error
   (`Qt_6.11_PRIVATE_API`), so the script installs Fedora's official
   `quickshell` 0.2.1 instead and versionlocks it.
2. **Installs packages**: Hyprland, Qt/QML extras, kitty, firefox, nautilus,
   screenshot tools, `mesa-vulkan-drivers` (needed for software rendering in
   the VM), SDDM — then Quickshell 0.2.1 from the official Fedora repos.
   This is the long step — let it run.
3. **Downloads the Antonio font** (Google Fonts, OFL license) to
   `~/.local/share/fonts` — the LCARS-ish typeface used by the shell.
4. **Copies `hypr/hyprland.conf`** to `~/.config/hypr/hyprland.conf`.
   That file contains `exec-once = quickshell -p $HOME/lcars-shell/shell/shell.qml`,
   which is how the shell starts with Hyprland. **If your repo lives
   somewhere other than `~/lcars-shell`, edit that path.**

## Step 3 — First launch (5 minutes)

**Option A — pick Hyprland at login (easiest for the first run):**
Reboot, and on the login screen click your name, then the **gear icon** in
the bottom corner → choose **Hyprland** → log in.

**Option B — auto-login straight into LCARS (what the professor gets):**
```bash
bash scripts/setup-fedora.sh --autologin
sudo reboot
```
This enables SDDM autologin for your user with the Hyprland session. Boot →
LCARS, no clicks.

**Success looks like:** a black screen with an orange-bordered panel saying
"LCARS // SHELL v0.1", a top bar reading **FEDORA // LCARS** with workspace
pips and a live clock + stardate, a bottom strip showing **CPU / MEM / UP**
numbers updating every 2 seconds, and a left **MENU** column with buttons.
Take a screenshot (the `Print` key copies to clipboard) — that's your
**Phase 1 "Hello LCARS" deliverable**.

## Step 4 — If something's off (sorted by likelihood)

| Symptom | Fix |
|---|---|
| `quickshell: symbol lookup error ... Qt_6.11_PRIVATE_API` | You got a COPR quickshell build instead of Fedora's. Fix: `sudo dnf --disablerepo='copr*' downgrade quickshell`, then re-run `bash scripts/setup-fedora.sh` (it versionlocks the official 0.2.1). |
| Hyprland crashes / black screen / never starts in the VM | Uncomment these in `~/.config/hypr/hyprland.conf` (software rendering via lavapipe):<br>`env = WLR_RENDERER, vulkan`<br>`env = WLR_NO_HARDWARE_CURSORS, 1`<br>Then restart the session. |
| Shell doesn't appear but Hyprland runs | The `exec-once` path is wrong (repo not at `~/lcars-shell`), or Quickshell hit a QML error. Open a terminal (Super+Return → kitty) and run it manually to see the error:<br>`pkill quickshell`<br>`quickshell -p ~/lcars-shell/shell/shell.qml` |
| `LcarsStyle is not defined` | `shell/qmldir` must sit next to `LcarsStyle.qml` (it does in the repo — re-clone if you deleted it). |
| Bars overlap windows | Quickshell panels usually reserve space automatically; if not, check the `exclusionMode` property in the Quickshell docs for your version. |
| CPU/MEM numbers stay frozen | `SystemReadout.qml` uses the 0.2.1 `Process` API (`command` as a list + `stdout: StdioCollector`). If quickshell was upgraded to another version, check https://quickshell.org/docs/ and adjust. |

## Step 5 — Iterate (this is the fun part)

Quickshell **hot-reloads QML on save**. Inside Hyprland:

1. Edit any file in `shell/` (e.g. change the title text in `TopBar.qml`,
   or a color in `LcarsStyle.qml`).
2. Save — the running shell reloads instantly.
3. Repeat. No compile, no restart, no command line.

Quick wins to try in order: change the title → recolor one panel →
add a button to the launcher → add a workspace pip behavior you like.

## Step 6 — Group rhythm

- Push after every working change; teammates pull and test.
- Roles are in `docs/PHASES.md` (Infra / Shell lead / Applets / Design-QA).
- Next milestones (in order): notifications popup, file viewer, network
  panel, volume OSD — each maps to a first-party Quickshell module.
- When the demo is solid: polish animations, set autologin, and export the
  VM as an `.ova` (steps in `docs/vm-virtualbox.md`) — that's the professor
  deliverable.
