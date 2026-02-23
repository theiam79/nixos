{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/core
    ../common/optional/niri.nix
    ../common/optional/battery.nix
  ];

  networking.hostName = "hodur";
}
