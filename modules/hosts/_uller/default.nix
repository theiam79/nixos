{ self, inputs, ... }:
{
  flake.nixosConfigurations.uller = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.uller ];
  };
}
