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
  # without a rebuild.
  #
  # The whole directory is linked as ONE symlink, deliberately. Declaring
  # individual entries (niri/config.kdl, niri/host.kdl) makes home-manager
  # collapse ~/.config/niri into a single read-only store directory, because
  # it symlinks the topmost directory it fully owns -- which also breaks
  # relative includes, since they then resolve inside the store.
  #
  # host.kdl therefore has to live inside the repo. It is gitignored and
  # created per-machine by the activation script below, pointing at this
  # host's file. config.kdl ends with `include optional=true "host.kdl"`.
  #
  # Note: reads osConfig, so this assumes home-manager runs as a NixOS module.
  flake.homeModules.niri = { config, lib, osConfig, ... }:
    let
      niriDir = "${config.home.homeDirectory}/nixos/config/niri";
    in
    {
      programs.fuzzel.enable = true;

      xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink niriDir;

      home.activation.niriHostConfig =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          if [ -d ${lib.escapeShellArg niriDir} ]; then
            run ln -sfn "hosts/${osConfig.networking.hostName}.kdl" \
              ${lib.escapeShellArg "${niriDir}/host.kdl"}
          fi
        '';
    };
}
