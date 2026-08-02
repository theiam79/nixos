{ ... }:
{
  flake.nixosModules.users = { pkgs, ... }: {
    users.users.tyler = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      # Pinned so an existing home directory keeps its ownership after the
      # theiam79 -> tyler rename. See the note in README about `mv`ing it.
      uid = 1000;
    };

    environment.systemPackages = with pkgs; [
      vim
      wget
      git
    ];
  };
}
