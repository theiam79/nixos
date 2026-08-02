{ inputs, ... }:
{
  # Secure Boot via lanzaboote: signed bootloader + signed unified kernel
  # images. Needed because Battlefield 6's Javelin anti-cheat requires Secure
  # Boot (and TPM 2.0) to be enforced in firmware, and plain systemd-boot is
  # unsigned so it will not load once enforcement is on.
  #
  # Still marked experimental upstream, and kernel updates now go through a
  # signing step.
  #
  # Enrollment is a one-time manual step, in this order:
  #   1. install and boot NixOS normally with Secure Boot OFF
  #   2. enable this module, rebuild, check `bootctl status`
  #   3. firmware -> Setup Mode (do NOT pick "Clear All Secure Boot Keys",
  #      that drops the dbx; erase only the Platform Key)
  #   4. sudo sbctl enroll-keys --microsoft
  #   5. reboot, enable Secure Boot (Enforce), confirm `bootctl status`
  #      reports "Secure Boot: enabled (user)"
  #   6. test booting Windows before trusting it
  #
  # --microsoft is not optional: it keeps Microsoft's certificates, which
  # Windows Boot Manager is signed with, and which the discrete GPU's option
  # ROM is signed with. Drop them and you can lose display output at POST.
  flake.nixosModules.secureBoot = { lib, pkgs, ... }: {
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    environment.systemPackages = [ pkgs.sbctl ];

    # lanzaboote installs its own signed stub in place of systemd-boot.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      # Older lanzaboote used /etc/secureboot; confirm against the pinned
      # version before enrolling, since sbctl must write to the same path.
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
