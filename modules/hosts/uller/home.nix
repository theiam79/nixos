{ self, ... }:
{
  flake.homeModules.uller = {
    imports = with self.homeModules; [
      shell
      git
      packages
      niri
      noctalia
      mise
    ];

    home.username = "tyler";
    home.homeDirectory = "/home/tyler";
    home.stateVersion = "26.05";
  };
}
