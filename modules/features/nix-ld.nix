{ ... }:
{
  # home-ops installs its toolchain through mise's aqua backend (prebuilt
  # binaries). Most are static Go and run fine, but bws (Bitwarden Secrets
  # Manager CLI), python-build-standalone and friends are dynamically linked
  # and need an FHS-ish loader. Also what makes the native Claude Code
  # installer work instead of the nixpkgs package.
  #
  # Deliberately does NOT replicate the home-ops tool list: .mise.toml is the
  # source of truth there and Renovate manages its version pins.
  flake.nixosModules.nixLd = {
    programs.nix-ld.enable = true;
  };
}
