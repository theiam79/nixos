{ ... }:
{
  # Resolves secrets declared in a repo's secretspec.toml from a provider,
  # here the OS keyring via the freedesktop Secret Service API. home-ops uses
  # it to get BWS_ACCESS_TOKEN without the token ever touching a file, an env
  # var, a dotfile or the Nix store:
  #
  #   secretspec run -- bws run -- task talos:...
  #
  # Deliberately the standalone CLI, not devenv: devenv duplicates mise's job
  # and would drift against the non-Nix WSL side of home-ops.
  #
  # Depends on the `keyring` NixOS feature for the Secret Service daemon and
  # its PAM unlock -- secretspec's keyring provider talks to that same daemon.
  #
  # Per-machine setup is runtime state in ~/.config/secretspec/, so it is not
  # declared here:
  #
  #   secretspec config global init      # pick the keyring provider (0.17+)
  #   secretspec set BWS_ACCESS_TOKEN    # prompts, stores in the keyring
  #   secretspec check                   # verify everything resolves
  flake.homeModules.secretspec = { pkgs, ... }: {
    home.packages = [ pkgs.secretspec ];
  };
}
