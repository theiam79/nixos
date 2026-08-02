{ ... }:
{
  # One feature, both classes: the compositor on the NixOS side and the
  # dotfile wiring on the home-manager side.
  flake.nixosModules.niri = { pkgs, ... }: {
    programs.niri.enable = true;

    services.xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
    };
    services.displayManager.ly.enable = true;
    services.libinput.enable = true;

    environment.systemPackages = with pkgs; [
      alacritty
      xwayland-satellite
    ];
  };

  # Config stays an out-of-store symlink so it can be edited and reloaded
  # without a rebuild. config.kdl is shared; host.kdl is per-machine and
  # pulled in by `include optional=true "host.kdl"` at the end of config.kdl.
  #
  # Note: reads osConfig, so this assumes home-manager runs as a NixOS module.
  flake.homeModules.niri = { config, osConfig, ... }:
    let
      repo = "${config.home.homeDirectory}/nixos";
      link = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      programs.fuzzel.enable = true;

      xdg.configFile."niri/config.kdl".source = link "${repo}/config/niri/config.kdl";
      xdg.configFile."niri/host.kdl".source =
        link "${repo}/config/niri/hosts/${osConfig.networking.hostName}.kdl";
    };
}
