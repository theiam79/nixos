{ pkgs, ... }:
{
  programs.niri.enable = true;
  programs.firefox.enable = true;

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
}
