{ ... }:
{
  # Its own feature rather than riding along inside niri: a browser is not a
  # compositor concern, and uller should get it without inheriting anything
  # else laptop-shaped.
  flake.nixosModules.firefox = {
    programs.firefox.enable = true;
  };
}
