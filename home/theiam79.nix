{ ... }:
{
  imports = [
    ./common/core
    ./common/optional/niri.nix
    ./common/optional/noctalia.nix
  ];

  home.username = "theiam79";
  home.homeDirectory = "/home/theiam79";
  home.stateVersion = "25.05";
}
