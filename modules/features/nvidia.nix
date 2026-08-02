{ ... }:
{
  flake.nixosModules.nvidia = { config, ... }: {
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.graphics = {
      enable = true;
      # 32-bit userspace for Steam / Proton.
      enable32Bit = true;
    };

    hardware.nvidia = {
      # Mandatory on Blackwell (RTX 50-series), not a preference: the
      # proprietary kernel modules do not support these GPUs at all.
      open = true;

      # Required for Wayland, and so niri gets a working session.
      modesetting.enable = true;

      nvidiaSettings = true;

      # Desktop, always on mains -- no runtime power management.
      powerManagement.enable = false;

      # Blackwell needs >= 570. Check `nvidiaPackages.stable.version` against
      # the pinned nixpkgs; fall back to `.beta` or `.latest` if it is older.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
