{ self, ... }:
{
  flake.nixosModules.hodur = {
    imports = with self.nixosModules; [
      # _hardware.nix keeps the name nixos-generate-config expects and is
      # imported by path: the leading underscore makes import-tree skip it,
      # so it stays a plain NixOS module and can be regenerated verbatim.
      ./_hardware.nix

      homeManager
      nixSettings
      boot
      locale
      networking
      users
      fonts
      audio

      niri
      battery
      windowsBoot
    ];

    networking.hostName = "hodur";
    system.stateVersion = "25.05";

    home-manager.users.tyler = self.homeModules.hodur;

    custom.windowsBoot = {
      enable = true;
      efiUuid = "92D5-3AA7";
    };
  };
}
