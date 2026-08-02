{ ... }:
{
  # Secret Service provider for the BWS access token, read via secretspec's
  # keyring provider. niri is not a full DE, so the daemon has to be enabled
  # explicitly rather than coming along with GNOME.
  flake.nixosModules.keyring = { pkgs, ... }: {
    services.gnome.gnome-keyring.enable = true;

    # PAM unlock at login: the token is then available all session with no
    # prompts. ly's PAM service substacks `login` (see the nixpkgs ly module),
    # so configuring `login` covers it -- unlike greetd, which does not
    # include the login stack (nixpkgs#357201).
    #
    # Verify after the first switch: `cat /etc/pam.d/ly` should show the
    # gnome_keyring rules. If not, set
    # security.pam.services.ly.enableGnomeKeyring = true directly.
    security.pam.services.login.enableGnomeKeyring = true;

    # Prompter for Secret Service requests outside a full desktop session.
    environment.systemPackages = [ pkgs.gcr ];
  };
}
