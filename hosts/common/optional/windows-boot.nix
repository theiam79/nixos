{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.windowsBoot;
in
{
  options.hardware.windowsBoot.efiUuid = lib.mkOption {
    type = lib.types.str;
    description = "UUID of the Windows EFI System Partition";
  };

  config = {
    fileSystems."/boot/efi/windows" = {
      device = "/dev/disk/by-uuid/${cfg.efiUuid}";
      fsType = "vfat";
    };

    # Copy Windows bootloader to the NixOS ESP so systemd-boot auto-detects it.
    # Re-syncs on every rebuild in case Windows updates its bootloader.
    system.activationScripts.syncWindowsBootloader = ''
      ${pkgs.rsync}/bin/rsync -a /boot/efi/windows/EFI/Microsoft /boot/EFI/
    '';

    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.timeout = 5;
  };
}
