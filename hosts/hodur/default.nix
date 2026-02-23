{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/core
    ../common/optional/niri.nix
    ../common/optional/battery.nix
    ../common/optional/windows-boot.nix
  ];

  networking.hostName = "hodur";
  hardware.windowsBoot.efiUuid = "92D5-3AA7";
}
