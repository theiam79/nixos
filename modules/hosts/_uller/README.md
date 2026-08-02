# uller — staged, not yet active

This directory is named `_uller` so `import-tree` skips it (it ignores any
path containing `/_`). Nothing in here is evaluated, so an incomplete host
cannot break `nix flake check` for the whole flake.

## To activate

1. Install NixOS on uller normally (plain systemd-boot, Secure Boot **off** —
   the installer ISO is unsigned too).
2. Copy the generated hardware config in as `_hardware.nix`:
   ```
   cp /etc/nixos/hardware-configuration.nix modules/hosts/_uller/_hardware.nix
   ```
   Keep the leading underscore: it stays a plain NixOS module that
   `nixos-generate-config` can regenerate verbatim.
3. Check `system.stateVersion` and `home.stateVersion` in this directory match
   the release actually installed.
4. Rename the directory so import-tree picks it up:
   ```
   git mv modules/hosts/_uller modules/hosts/uller
   ```
5. `nix flake check && nixos-rebuild build --flake .#uller`

## Then, separately

Secure Boot enrollment is a manual one-time step — see the comment block in
`modules/features/secure-boot.nix` for the order. Do it only after the machine
boots and rebuilds cleanly without it.

## When hodur's drive is added

Adding the harvested disk later means regenerating `_hardware.nix` (or adding
the `fileSystems` entry by hand). If it becomes the Steam library, it must be
ext4/btrfs — Proton on NTFS breaks, and ReFS is unreadable from Linux.
