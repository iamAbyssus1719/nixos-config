<div align="center">
  <img src="https://icon.icepanel.io/Technology/svg/NixOS.svg" alt="NixOS Logo" width="160"/>

  # NixOS System Configuration

  A modular and reproducible NixOS configuration utilizing Home Manager for user-environment management.
</div>

---

## Project Structure

```
.
├── configuration.nix
├── hardware-configuration.nix
├── home-manager
│   ├── home.nix
│   └── modules
│       ├── fastfetch.nix
│       ├── quickshell.nix
│       ├── starship.nix
│       ├── wezterm.nix
│       └── zsh.nix
├── modules
│   ├── desktop
│   │   ├── hyprland.nix
│   │   ├── noctalia.nix
│   │   └── sddm.nix
│   ├── programs
│   │   └── vscode.nix
│   └── system
│       ├── audio.nix
│       └── bluetooth.nix
├── quickshell
│   ├── Captura
│   │   └── shell.qml
│   ├── lock
│   │   └── shell.qml
│   ├── Menu
│   │   └── shell.qml
│   └── Reloj
│       └── shell.qml
└── README.md
```

### Component Overview

* **`configuration.nix`**: Primary system entrypoint.
* **`hardware-configuration.nix`**: Machine-specific hardware definitions (automatically generated).
* **`home-manager/`**: User-space configurations and dotfiles management.
* **`modules/`**: Modular system-level configurations categorized by desktop environment, applications, and core system services.
* **`quickshell/`**: Custom QML-based shell interfaces and widgets.

## Core Components

* **Window Manager:** Hyprland
* **Display Manager:** SDDM
* **Desktop Tools:** Noctalia, UWSM
* **Custom Widgets:** Quickshell (captures, lockscreen, menu, clock)
* **Terminal Environment:** WezTerm, Zsh, Starship, Fastfetch
* **Configuration Management:** Home Manager

## Deployment and Installation

### Prerequisites

* NixOS 26.05
* Git
* Home Manager (release-26.05 channel)

### 1. Repository Setup

NixOS reads configuration files directly from `/etc/nixos`.

Backup the existing system configuration:

```bash
sudo cp -r /etc/nixos /etc/nixos.backup
```

Clone this repository into `/etc/nixos`:

```bash
sudo git clone https://github.com/iamAbyssus1719/nixos-config.git /etc/nixos
```

> **Note:** Update the repository URL to match your personal target repository.

### 2. Hardware Configuration

The `hardware-configuration.nix` file contains settings tailored to specific physical hardware.

When deploying to a new host, generate a clean hardware profile:

```bash
sudo nixos-generate-config
```

Ensure the generated `hardware-configuration.nix` is retained for the active machine.

### 3. Build and Switch

To compile and activate the configuration:

```bash
sudo nixos-rebuild switch
```

## Architectural Notes

* **Path Conventions:** Default path evaluation relies on `/etc/nixos/configuration.nix`. Maintain this path or configure a corresponding symbolic link.
* **Hardware Isolation:** Avoid sharing `hardware-configuration.nix` across different machines to prevent partitioning or driver conflicts.
* **Flakes Usage:** This deployment uses traditional Nix channels and Home Manager modules (non-Flake setup).
* **Rollback Capabilities:** NixOS creates system generations upon build, enabling instant rollbacks via the bootloader or `nixos-rebuild --rollback` if regressions occur.
