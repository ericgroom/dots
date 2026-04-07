# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository using Nix flakes to manage system configuration across multiple machines:
- **macbookair**: Apple Silicon Mac (aarch64-darwin) - primary development machine
- **desktop**: NixOS gaming/desktop workstation (x86_64-linux)

## Commands

All configuration is managed through Nix flakes in the `nix/` directory.

```bash
# Apply configuration on macOS (run from nix/ directory)
darwin-rebuild switch --flake .#macbookair

# Apply configuration on NixOS
sudo nixos-rebuild switch --flake .#desktop

# Update flake dependencies
nix flake update
```

## Architecture

```
nix/
├── flake.nix              # Flake entry point - defines all machine outputs
├── hosts/                 # Machine-specific configurations
│   ├── macbookair/        # Apple Silicon Mac config
│   └── desktop/           # NixOS config
├── home/                  # Home-manager user configuration
│   ├── default.nix        # Main home config, imports all modules
│   └── modules/           # Modular user configs (shell, git, nvim, ssh)
└── modules/               # System-level modules
    ├── common_cli.nix     # Shared CLI tools across all machines
    ├── darwin/            # macOS-specific (docker, iosdev)
    └── nixos/             # NixOS-specific (nvidia, gaming)

nvim/.config/nvim/         # Neovim config (symlinked by home-manager)
```

**Configuration flow**: `flake.nix` → `hosts/<machine>/default.nix` → `configuration.nix` + home-manager modules

## Key Patterns

- Each host's `default.nix` wires together nix-darwin/NixOS with home-manager
- System packages go in host `configuration.nix`, user tools go in `home/modules/`
- The `_1passwordAgentPath` option configures SSH agent integration per-machine
- Neovim config lives outside nix and is symlinked via `home/modules/nvim.nix`
