<div align="center">
  <img src="https://icon.icepanel.io/Technology/svg/NixOS.svg" alt="NixOS Logo" width="160"/>

  # NixOS System Configuration

  A modular and reproducible NixOS configuration using Flakes and Home Manager to manage system and user environments.
</div>

---

## Project Structure

```text
.
├── flake.lock
├── flake.nix
├── home-manager
│   ├── configs
│   │   ├── hyprland
│   │   │   ├── hyprland.lua
│   │   │   └── scripts
│   │   │       ├── captura.sh
│   │   │       ├── Flotantes.sh
│   │   │       └── Opacidad.sh
│   │   ├── noctalia
│   │   │   ├── assets
│   │   │   │   ├── HORIZONTAL.jpg
│   │   │   │   ├── VERTICAL.jpg
│   │   │   │   └── YUKI.jpg
│   │   │   └── settings.nix
│   │   └── quickshell
│   │       ├── Captura
│   │       │   └── shell.qml
│   │       ├── lock
│   │       │   └── shell.qml
│   │       ├── Menu
│   │       │   └── shell.qml
│   │       └── Reloj
│   │           └── shell.qml
│   ├── home.nix
│   └── modules
│       ├── desktop
│       │   ├── hyprland.nix
│       │   ├── noctalia.nix
│       │   └── quickshell.nix
│       ├── programs
│       │   ├── fastfetch.nix
│       │   ├── vscode.nix
│       │   └── vscode-settings.nix
│       ├── shell
│       │   ├── starship.nix
│       │   └── zsh.nix
│       └── terminal
│           └── wezterm.nix
├── hosts
│   └── nixos
│       ├── configuration.nix
│       └── hardware-configuration.nix
├── modules
│   ├── desktop
│   │   ├── hyprland.nix
│   │   ├── noctalia.nix
│   │   └── sddm.nix
│   ├── services
│   │   └── server.nix
│   └── system
│       ├── audio.nix
│       └── bluetooth.nix
└── README.md
```

## Component Overview

### System Configuration

- **`flake.nix`**: Main entry point for the Flake. Defines dependencies and combines NixOS and Home Manager configurations.
- **`flake.lock`**: Locks dependency versions to ensure reproducible builds.
- **`hosts/nixos/`**: Host-specific configuration, including the main NixOS configuration and hardware definitions.
- **`modules/`**: System-level modules for desktop components, services, audio and Bluetooth.

### Home Manager

- **`home-manager/home.nix`**: Main entry point for the user configuration.
- **`home-manager/modules/`**: User-level modules organized by category.
- **`home-manager/configs/`**: Custom application configurations, scripts, assets and QML files.

Home Manager manages user applications, shell environments, editor settings and configuration files independently from the system-level modules.

## Core Components

| Category | Components |
|---|---|
| Operating System | NixOS 26.05 |
| Window Manager | Hyprland |
| Display Manager | SDDM |
| Desktop Tools | Noctalia, UWSM |
| Custom Widgets | QuickShell |
| Terminal | WezTerm |
| Shell | Zsh, Starship |
| System Information | Fastfetch |
| Code Editor | Visual Studio Code |
| Configuration Management | Nix Flakes, Home Manager |
| Web Development | Apache, PHP, MariaDB, Node.js, Composer |

## Architecture

The configuration follows a modular structure that separates system-level and user-level responsibilities.

### NixOS Modules

Located in `modules/`, these modules manage system-wide configuration:

- System services and daemons.
- Audio and Bluetooth.
- Display manager.
- System-level desktop configuration.
- Server environment.

### Home Manager Modules

Located in `home-manager/modules/`, these modules manage the user environment:

- Application installation and extensions.
- Application settings.
- Terminal and shell configuration.
- Hyprland user configuration.
- Noctalia and QuickShell configurations.
- Custom scripts and assets.

This separation makes the configuration easier to maintain, reuse and extend.

## Deployment and Installation

### Prerequisites

- NixOS 26.05.
- Git.
- Nix with Flakes enabled.

Home Manager is integrated as a NixOS module through the Flake, so it does not need to be installed separately through a traditional channel.

### 1. Enable Flakes

Ensure that experimental features are enabled in your NixOS configuration:

```nix
nix.settings.experimental-features = [
  "nix-command"
  "flakes"
];
```

### 2. Clone the Repository

Back up your existing configuration:

```bash
sudo cp -r /etc/nixos /etc/nixos.backup
```

Clone the repository:

```bash
sudo git clone https://github.com/iamAbyssus1719/nixos-config.git /etc/nixos
```

If `/etc/nixos` already contains a Git repository, use a separate directory or back up and move the existing configuration before cloning.

### 3. Hardware Configuration

The `hardware-configuration.nix` file contains hardware-specific settings generated for the machine.

When deploying to another host, generate its hardware configuration:

```bash
sudo nixos-generate-config
```

Keep the generated `hardware-configuration.nix` for the target machine. Do not blindly reuse another computer's hardware configuration.

### 4. Build and Switch

Check the Flake configuration:

```bash
nix flake check /etc/nixos
```

Build the system without activating it:

```bash
sudo nixos-rebuild dry-build --flake /etc/nixos#nixos
```

Apply the configuration:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Updating Dependencies

Update the dependencies defined in `flake.nix`:

```bash
nix flake update /etc/nixos
```

Then rebuild the system:

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Git Workflow

The configuration is maintained in a Git repository.

Because Flakes evaluate Git-tracked files, newly created configuration files must be added to Git before Nix can use them:

```bash
git add .
```

Check the current repository status:

```bash
git status
```

A commit is not required before rebuilding. Staging the files is sufficient.

## Rollback

NixOS creates system generations when a new configuration is activated.

To return to the previous generation:

```bash
sudo nixos-rebuild switch --rollback
```

You can also select a previous generation from the bootloader menu.

---

## License

This repository is intended for personal use and as a reference for my NixOS configuration.
