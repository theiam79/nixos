{ ... }:
{
  flake.nixosModules.nixSettings = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Keep the store from growing without bound. Matters more than usual here:
    # each generation keeps a kernel + initrd on the ESP.
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    nix.optimise.automatic = true;
  };
}
