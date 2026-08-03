{ ... }:
{
  # Secret Service provider for the BWS access token, read via secretspec's
  # keyring provider. niri is not a full DE, so the daemon has to be enabled
  # explicitly rather than coming along with GNOME.
  flake.nixosModules.keyring = { pkgs, ... }: {
    services.gnome.gnome-keyring.enable = true;

    # PAM unlock at login, so the token is available all session with no
    # prompts.
    #
    # ly's PAM rules substack `login`, but that does NOT carry
    # enableGnomeKeyring through -- verified on uller, where /etc/pam.d/ly had
    # no gnome_keyring line with only `login` set. The ly service declares
    # useDefaultRules = false, so it needs setting on the service itself.
    # `login` stays set for console logins.
    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.ly.enableGnomeKeyring = true;

    # Prompter for Secret Service requests outside a full desktop session.
    environment.systemPackages = [ pkgs.gcr ];
  };
}
