# Vishwa Linux 1.0 "Cosmos" 🌌

A custom, branded Debian-based Linux distribution with the **Cinnamon** desktop.

* **Base:** Debian 12 (bookworm), `amd64`
* **Desktop:** Cinnamon
* **Target size:** ~750 MB live ISO (hybrid: BIOS + UEFI)
* **Theme:** cosmic blue / purple, English branding ("Vishwa Linux")

Everything here is a normal **live-build** project, so the ISO is built with the
official Debian live tooling. The ISO is created in the cloud by
**GitHub Actions**, so you do not need Linux on your own PC.

---

## What is branded

| Component | What you get |
|-----------|--------------|
| Logo | Cosmic planet + orbit emblem (`assets/logo.svg`) |
| Wallpaper | 1920×1080 cosmic wallpaper + login background |
| Boot menu (BIOS) | Themed **syslinux/isolinux** splash + colours |
| Boot menu (UEFI) | Themed **GRUB** splash + colours |
| Boot splash | Custom **Plymouth** theme (pulsing logo) |
| Login screen | **slick-greeter** with Vishwa background |
| Desktop | Wallpaper + dark GTK theme applied by default |
| Identity | `Vishwa Linux 1.0 (Cosmos)` in `os-release`, `lsb-release`, `issue` |

---

## Repository layout

```
auto/                     live-build "auto" scripts (config / build / clean)
config/package-lists/     packages installed into the image
config/includes.chroot/   files copied into the live filesystem
config/includes.binary/   files copied onto the ISO root
config/hooks/live/        chroot + binary hooks (branding, boot theming)
assets/                   SVG source art (rendered to PNG during the build)
tools/build-assets.sh     renders assets/*.svg  ->  PNGs used by the build
.github/workflows/        the GitHub Actions build pipeline
```

## How to build

1. Create a **new empty GitHub repository** (e.g. `vishwa-linux`).
2. Push this folder to it (branch `main`).
   ```bash
   git init
   git add .
   git commit -m "Vishwa Linux 1.0 Cosmos"
   git branch -M main
   git remote add origin https://github.com/<you>/vishwa-linux.git
   git push -u origin main
   ```
3. Open the repo → **Actions** → **Build Vishwa Linux ISO** → **Run workflow**.
4. Wait ~20–40 minutes, then download the artifact **`vishwa-linux-iso`**.
   (Or push a tag like `v1.0` to also create a GitHub **Release** with the ISO.)

### Testing the ISO

* **Virtual machine:** create a VM (VirtualBox / VMware / QEMU) with 2 GB+ RAM and
  boot the ISO.
* **USB stick:** `sudo dd if=Vishwa-Linux-1.0-amd64.iso of=/dev/sdX bs=4M status=progress`
  (replace `/dev/sdX` with your USB device — double-check it!).

Live user: **`vishwa`** (autologin, passwordless sudo).

---

## Customising

* **Colours / logo / wallpaper:** edit the SVGs in `assets/` and re-run the build.
  `tools/build-assets.sh` rasterises them with `rsvg-convert` at the sizes the
  bootloaders need (640×480 syslinux, 800×600 GRUB, 1920×1080 desktop).
* **Packages:** edit `config/package-lists/*.list.chroot`.
* **Live user / hostname / locale:** see `--bootappend-live` in `auto/config`.
* **ISO name / volume:** `--iso-application`, `--iso-volume` in `auto/config`.

---

## Known limitations (v1)

* This is a **live system only** — there is no graphical installer embedded
  (that would push the size well past 750 MB). Ask if you want an installable
  variant (Calamares or the Debian installer).
* **Non-free firmware is not included**, to stay under the size budget. This
  means some Wi-Fi/GPU hardware may not work out of the box.
* `--apt-recommends` is **off** for size, so a few optional apps are absent.
