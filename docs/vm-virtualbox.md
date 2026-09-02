# VirtualBox Notes — running the LCARS shell in a VM

> This is the single biggest technical risk in the project, so it gets its own
> doc. The rule: **test Hyprland in the actual VirtualBox VM in Phase 1, not
> at the end.**

## Why a VM is tricky

Hyprland is a 3D Wayland compositor. VirtualBox guests get no GPU Vulkan
support and only old OpenGL (3.x) via the guest video driver — so Hyprland
can't use a hardware renderer. This is a *known, solved-ish* problem:

- VirtualBox has no Vulkan → Hyprland falls back to **software rendering**:
  Mesa's **lavapipe** (software Vulkan) or the pixman fallback. It works, it's
  just slower — fine for a demo at a modest resolution.
- Recommendation from community write-ups of running Hyprland in VirtualBox:
  enable 3D acceleration, raise VRAM, trim animations, use a low resolution.
- If you can, develop on QEMU/KVM (`virtio-gpu` + `virgl`) or a physical
  machine, and use VirtualBox only for the final professor image.

## Recommended VirtualBox settings

| Setting | Value |
|---|---|
| OS type | Fedora 64-bit |
| RAM | 4096 MB (more is better) |
| CPUs | 2–4 |
| Video memory | **256 MB** (default 16 MB is not enough) |
| 3D acceleration | **Enabled** |
| Graphics controller | VMSVGA (default for Linux guests) |
| Disk | 40 GB dynamic VDI |

Set from the GUI (Settings → System/Display) or:

```bash
VBoxManage modifyvm "LCARS" --memory 4096 --cpus 4 --vram 256 --accelerate3d on
```

## Install path inside the VM

```bash
# from the repo:
bash scripts/setup-fedora.sh
```

## If Hyprland fails to start in the VM

Uncomment these in `~/.config/hypr/hyprland.conf` (software rendering via
lavapipe; needs `mesa-vulkan-drivers`, which the setup script installs):

```conf
env = WLR_RENDERER, vulkan
env = WLR_NO_HARDWARE_CURSORS, 1
```

If the version of Hyprland you installed no longer accepts those, check the
Hyprland wiki's troubleshooting page and the [software rendering issue
#3516](https://github.com/hyprwm/Hyprland/issues/3516) for the current
recommended env vars. **Renderer fallback options change between Hyprland
versions — always verify against the version you actually installed.**

Also: keep the animation config modest (see `hypr/hyprland.conf`), and set an
explicit resolution if the auto-detected one is wrong:

```conf
monitor = Virtual-1, 1600x900@60, 0x0, 1
```

## Auto-login (so the professor just boots into LCARS)

Option A — SDDM autologin (after `sudo dnf install sddm`):

```bash
sudo mkdir -p /etc/sddm.conf.d
printf '[Autologin]\nUser=%s\nSession=hyprland\n' "$USER" | sudo tee /etc/sddm.conf.d/autologin.conf
sudo systemctl enable sddm
sudo systemctl set-default graphical.target
```

Option B — TTY autologin + start Hyprland from the shell (no display manager):

```bash
# enable autologin on tty1 (systemd getty override), then in ~/.bash_profile:
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec Hyprland
```

The setup script supports `--autologin` for Option A.

## Guest Additions

Install Guest Additions in the VM for a nicer mouse/resolution experience
(Devices → Insert Guest Additions CD → run the installer). Not strictly
required: Hyprland sets its own resolution via `monitor` and the shell is
keyboard-first anyway.

## Shipping to the professor (the `.ova`)

1. Finish the shell, set auto-login, reboot to confirm "boot → LCARS".
2. Power off the VM.
3. `File → Export Appliance` (or `VBoxManage export "LCARS" -o lcars.ova`).
4. Ship `lcars.ova` + the one-page README + the 2-minute demo script.

Professor flow: install VirtualBox → double-click `lcars.ova` → import →
Start → LCARS. No ISO, no installer, no command line.

## Alternative: QEMU/KVM for development

If anyone's host is Linux with KVM, develop there for smoothness:

```bash
qemu-system-x86_64 -enable-kvm -m 4096 -cpu host \
  -device virtio-vga-gl -display gtk,gl=on \
  -drive file=fedora.qcow2,if=virtio
```

Then still produce the VirtualBox `.ova` for delivery.
