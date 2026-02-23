{ ... }:
{
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo Doing this all by hand, btw";
    };
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.bitwarden-ssh-agent.sock";
  };
}
