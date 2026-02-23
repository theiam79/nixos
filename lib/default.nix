{ inputs, ... }:
{
  mkHost = hostname: system: inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ../hosts/${hostname}
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.theiam79 = import ../home/theiam79.nix;
          extraSpecialArgs = { inherit inputs; };
          backupFileExtension = "backup";
        };
      }
    ];
  };
}
