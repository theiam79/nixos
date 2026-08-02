{ ... }:
{
  flake.homeModules.git = {
    programs.git = {
      enable = true;
      settings.user = {
        name = "theiam79";
        email = "theiam79@gmail.com";
      };
    };
  };
}
