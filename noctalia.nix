{ pkgs, inputs, ... }:
{
  home-manager.users.theiam79 = {
    imports = [
      inputs.noctalia.homeModules.default
    ];
  
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          position = "top";
          widgets = {
            left = [
              {
                id = "SystemMonitor";
                showCpuTemp = true;
                showCpuUsage = true;
                showMemoryUsage = true;
              }
              {
                id = "ActiveWindow";
                showIcon = true;
                maxWidth = 145;
              }
              {
                id = "MediaMini";
                maxWidth = 145;
  
              }
            ];
            center = [
              {
                id = "Workspace";
                labelMode = "name";
                hideUnoccupied = false;
              }
            ];
            right = [
              {
                id = "ScreenRecorder";
              }
              {
                id = "Tray";
              }
              {
                id = "Battery";
              }
              {
                id = "Volume";
              }
              {
                id = "Clock";
                formatHorizontal = "HH:mm ddd, MMM dd";
              }
              {
                id = "ControlCenter";
              }
            ];
          };
        };
        colorSchemes = {
          darkMode = true;
          predefinedScheme = "Tokyo Night";
        };
        ui = {
          fontDefault = "JetBrainsMono Nerd Font Propo";
        };
        dock = {
          enabled = false;
        };
      };
    };
  };
}
