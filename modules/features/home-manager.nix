{ inputs, ... }:
{
  # Wires home-manager into a NixOS system. Hosts import this, then set
  # home-manager.users.<name> to the appropriate flake.homeModules.* module.
  flake.nixosModules.homeManager = {
    imports = [ inputs.home-manager.nixosModules.default ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
