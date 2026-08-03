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
    # Set on `login`, not `ly`. ly's PAM service is pure delegation --
    # auth/password substack login, account/session include login -- so the
    # rules belong in login's stack and ly inherits them by reference.
    #
    # Verify with /etc/pam.d/LOGIN, not /etc/pam.d/ly: the latter only ever
    # contains the four substack/include lines.
    #
    # Setting it on `ly` directly does nothing at all: nixpkgs gates the
    # enableGnomeKeyring rules behind useDefaultRules, and the ly module
    # declares useDefaultRules = false.
    security.pam.services.login.enableGnomeKeyring = true;

    environment.systemPackages = with pkgs; [
      # Prompter for Secret Service requests outside a full desktop session.
      gcr
      # secret-tool, for checking the keyring actually unlocked and for
      # putting the BWS token in by hand.
      libsecret
    ];
  };
}
