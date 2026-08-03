{ ... }:
{
  # G HUB is Windows/Mac only. libratbag (ratbagd) plus its GUI, piper, is the
  # Linux equivalent for G-series mice: DPI stages, polling rate, button
  # remapping, onboard profiles and LEDs.
  #
  # Worth knowing before fighting it: most G mice keep their profiles in
  # ONBOARD memory, so whatever is configured in G HUB under Windows carries
  # over to Linux by itself. piper is only needed to change settings from this
  # side. If the mouse already behaves the way you want, you may not need it
  # at all.
  #
  # libratbag device coverage trails new releases, so check with:
  #   ratbagctl list
  #
  # solaar handles Unifying/Bolt receivers -- pairing, battery, per-device
  # settings. Harmless if everything is wired.
  flake.nixosModules.logitech = { pkgs, ... }: {
    services.ratbagd.enable = true;

    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true; # solaar
    };

    environment.systemPackages = [ pkgs.piper ];
  };
}
