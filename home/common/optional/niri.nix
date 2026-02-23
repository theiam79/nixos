{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos/config";
in
{
  programs.fuzzel.enable = true;

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/niri";
    recursive = true;
  };
}
