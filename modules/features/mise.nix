{ ... }:
{
  # Just mise itself, for shell activation. The home-ops repo's .mise.toml is
  # the source of truth for the actual toolchain and Renovate manages those
  # pins -- do not mirror that tool list into this flake, and do not introduce
  # devenv (it duplicates mise's job and would drift against the WSL side).
  flake.homeModules.mise = {
    programs.mise = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
