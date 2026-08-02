{ self, inputs, ... }:
{
  flake.nixosConfigurations.hodur = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.hodur ];
  };
}
