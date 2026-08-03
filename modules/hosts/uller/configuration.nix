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
      rgb
      logitech

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

    # Bulk storage, shared with Windows. Host-specific, so it lives here
    # rather than in a feature -- and not in _hardware.nix, which
    # nixos-generate-config regenerates.
    #
    # Deliberately NOT mounted:
    #   sda1          ReFS Dev Drive -- unreadable from Linux, no free driver
    #   nvme2n1p*     the Windows system disk and its ESP
    #   nvme1n1p2     "Gjallar", Windows game installs
    boot.supportedFilesystems = [ "ntfs" ];

    fileSystems."/mnt/bulk" = {
      device = "/dev/disk/by-uuid/706AFA166AF9D8B4";
      fsType = "ntfs3";
      options = [
        "uid=1000"   # tyler
        "gid=100"    # users
        "umask=0022"
        # nofail so a missing or dirty disk cannot drop the machine into
        # emergency mode; automount defers it to first access.
        "nofail"
        "x-systemd.automount"
      ];
    };
  };
}
