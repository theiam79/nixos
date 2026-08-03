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
  # its PAM unlock. Per-machine provider selection is runtime state in
  # ~/.config/secretspec/ -- run `secretspec config init` once and pick
  # keyring; it is machine-specific, so it is not declared here.
  flake.homeModules.secretspec = { pkgs, ... }: {
    home.packages = [ pkgs.secretspec ];
  };
}
