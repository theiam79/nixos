{ ... }:
{
  flake.nixosModules.battery = {
    services.tuned.enable = true;
    services.upower.enable = true;
  };
}
