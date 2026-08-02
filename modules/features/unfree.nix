{ ... }:
{
  # Single source of truth for unfree allowances.
  #
  # nixpkgs.config.allowUnfreePredicate is one function, not a mergeable list:
  # if two feature modules each defined it, evaluation would fail with a
  # conflict. So features never set it themselves -- they add their package
  # names here instead.
  flake.nixosModules.unfree = { lib, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"

        "steam"
        "steam-unwrapped"
        "steam-run"
        "steam-original"
      ];
  };
}
