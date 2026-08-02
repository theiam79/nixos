{ ... }:
{
  # Neither host had any audio stack configured before; niri pulls in no
  # sound server of its own.
  flake.nixosModules.audio = {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
