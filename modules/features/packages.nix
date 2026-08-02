{ ... }:
{
  flake.homeModules.packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      neovim
      ripgrep
      tree
      nil
      nixpkgs-fmt
      nodejs
      gcc
      bitwarden-desktop
      # Used to review a built system against the running one before switching.
      nvd
    ];
  };
}
