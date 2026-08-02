{ ... }:
{
  flake.nixosModules.networking = {
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
  };
}
