{ ... }:
{
  flake.homeModules.git = {
    programs.git = {
      enable = true;
      userName = "theiam79";
      userEmail = "theiam79@gmail.com";
    };
  };
}
