{ self, ... }:
{
  flake.nixosModules.uller = {
    imports = with self.nixosModules; [
      ./_hardware.nix

      homeManager
      nixSettings
      boot
      locale
      networking
      users
      fonts
      audio
      unfree
      zram

      niri
      firefox
      nvidia
      steam

      nixLd
      keyring
      containers

      # Windows lives on its own disk with its own ESP, so nothing is
      # mirrored into the NixOS ESP -- unlike hodur. Secure Boot is enforced
      # in firmware for Battlefield 6, so systemd-boot is replaced by
      # lanzaboote.
      secureBoot
      rebootToWindows
    ];

    networking.hostName = "uller";

    # Set to the NixOS release this machine is actually installed from --
    # nixos-generate-config will suggest the right value. Never inherit it
    # from another host.
    system.stateVersion = "26.05";

    home-manager.users.tyler = self.homeModules.uller;

    custom.rebootToWindows.enable = true;
  };
}
