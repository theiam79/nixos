{ ... }:
{
  flake.nixosModules.containers = { pkgs, ... }: {
    # Rootless podman for the riskier autonomous Claude runs (repo
    # bind-mounted, egress allowlisted to Anthropic/GitHub/npm).
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };

    # Claude Code's built-in sandbox uses bubblewrap plus unprivileged user
    # namespaces. NixOS allows userns by default -- do not enable the hardened
    # profile, it turns them off and breaks the sandbox.
    environment.systemPackages = with pkgs; [
      bubblewrap
      socat
    ];
  };
}
