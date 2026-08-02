{ self, ... }:
{
  flake.homeModules.hodur = {
    imports = with self.homeModules; [
      shell
      git
      packages
      niri
      noctalia
    ];

    home.username = "tyler";
    home.homeDirectory = "/home/tyler";
    home.stateVersion = "25.05";
  };
}
