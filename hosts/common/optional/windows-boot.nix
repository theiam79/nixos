{ config, lib, ... }:
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

    boot.loader.systemd-boot.extraEntries = {
      "windows.conf" = ''
        title     Windows
        sort-key  0-windows
        efi       /efi/windows/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };

    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.timeout = 5;
  };
}
