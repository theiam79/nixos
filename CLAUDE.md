# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Deploy

```bash
# Rebuild and switch to the new configuration
sudo nixos-rebuild switch --flake .#hodur

# Build without switching (for testing)
sudo nixos-rebuild build --flake .#hodur

# Update flake inputs
nix flake update

# Update a single input
nix flake lock --update-input <input-name>
```

## Architecture

This is a modular NixOS flake configuration. Currently manages one Intel laptop host (`hodur`) running Niri (Wayland compositor) with the Ly display manager. The structure supports adding more hosts easily.

### Directory Layout

```
flake.nix                    # Inputs + mkHost calls for each machine
lib/default.nix              # mkHost helper (wraps nixpkgs.lib.nixosSystem)
hosts/
  common/
    core/                    # Shared by all hosts (boot, networking, locale, users, nix settings)
    optional/                # Opt-in system modules (niri.nix, battery.nix)
  hodur/                     # Host-specific config + hardware-configuration.nix
home/
  common/
    core/                    # Shared home-manager modules (shell, git, packages)
    optional/                # Opt-in home modules (niri dotfiles, noctalia bar)
  theiam79.nix               # User glue: imports core + optional home modules
config/niri/config.kdl       # Niri compositor config (KDL format, symlinked to ~/.config/niri)
```

### Key Patterns

**mkHost helper**: `lib/default.nix` exports `mkHost hostname system` which wraps `nixpkgs.lib.nixosSystem` with common boilerplate (specialArgs, home-manager module integration, extraSpecialArgs for inputs).

**Core + optional split**: `hosts/common/core/` is imported by every host. `hosts/common/optional/` modules are imported per-host as needed (e.g. `hodur` imports `niri.nix` and `battery.nix`). Same pattern for `home/common/`.

**Dotfile symlinks**: `home/common/optional/niri.nix` uses `config.lib.file.mkOutOfStoreSymlink` to symlink `~/nixos/config/niri` into `~/.config/niri`. The repo is expected to be cloned at `~/nixos`.

**Flake input passing**: `inputs` are available in system modules via `specialArgs` and in home-manager modules via `extraSpecialArgs`.

**Home-manager as NixOS module**: Home-manager is integrated as a NixOS module (not standalone), configured in the `mkHost` helper.

### Adding a New Host

1. Create `hosts/<name>/default.nix` importing `../common/core` plus any optional modules
2. Add `hosts/<name>/hardware-configuration.nix`
3. Add `<name> = lib.mkHost "<name>" "x86_64-linux";` to `flake.nix`
