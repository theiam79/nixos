{ ... }:
{
  # Unfree allowances live in modules/features/unfree.nix, not here.
  #
  # Keep the Steam library on a Linux-native filesystem (ext4/btrfs). Proton
  # on NTFS breaks on case sensitivity, permissions and symlinks, and ReFS is
  # not readable from Linux at all.
  flake.nixosModules.steam = {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
