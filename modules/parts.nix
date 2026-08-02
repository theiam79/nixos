{ inputs, ... }:
{
  imports = [
    # Adds home-manager options to flake-parts.
    inputs.home-manager.flakeModules.home-manager
  ];

  systems = [ "x86_64-linux" ];

  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixpkgs-fmt;

    devShells.default = pkgs.mkShell {
      packages = with pkgs; [ nil nixpkgs-fmt nvd ];
    };
  };
}
