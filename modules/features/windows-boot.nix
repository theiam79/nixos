{ ... }:
{
  # Mirrors the Windows bootloader from its own ESP into the NixOS ESP so
  # systemd-boot auto-detects it and offers a cold-boot menu entry.
  #
  # The copy is one-way: Windows never writes to the NixOS ESP, so the two
  # bootloaders stay isolated. Only needed where Windows lives on a separate
  # ESP that systemd-boot cannot read directly (it can only load binaries
  # from its own ESP or an XBOOTLDR partition on the same disk).
  flake.nixosModules.windowsBoot = { config, lib, pkgs, ... }:
    let
      cfg = config.custom.windowsBoot;
    in
    {
      options.custom.windowsBoot = {
        enable = lib.mkEnableOption "mirroring the Windows bootloader into the NixOS ESP";

        efiUuid = lib.mkOption {
          type = lib.types.str;
          description = "UUID of the Windows EFI System Partition.";
          example = "92D5-3AA7";
        };

        mountPoint = lib.mkOption {
          type = lib.types.str;
          default = "/boot/efi/windows";
          description = "Where the Windows ESP is mounted.";
        };
      };

      config = lib.mkIf cfg.enable {
        # nofail so a missing or replaced Windows disk degrades to "no Windows
        # entry" instead of dropping the machine into emergency mode at boot.
        fileSystems.${cfg.mountPoint} = {
          device = "/dev/disk/by-uuid/${cfg.efiUuid}";
          fsType = "vfat";
          options = [ "nofail" "umask=0077" ];
        };

        # Re-syncs on every rebuild so Windows Update's bootloader changes get
        # picked up. Warns rather than failing the activation if the Windows
        # ESP is not mounted -- a rebuild should never be blocked by it.
        system.activationScripts.syncWindowsBootloader = ''
          if [ -d ${lib.escapeShellArg cfg.mountPoint}/EFI/Microsoft ]; then
            ${pkgs.rsync}/bin/rsync -a --delete \
              ${lib.escapeShellArg cfg.mountPoint}/EFI/Microsoft \
              ${config.boot.loader.efi.efiSysMountPoint}/EFI/
          else
            echo "windows-boot: ${cfg.mountPoint}/EFI/Microsoft not found, skipping bootloader sync" >&2
          fi
        '';
      };
    };
}
