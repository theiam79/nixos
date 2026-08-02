{ inputs, ... }:
{
  flake.homeModules.noctalia = {
    imports = [ inputs.noctalia.homeModules.default ];

    # Renamed from programs.noctalia-shell upstream. Settings are now written
    # as TOML to ~/.config/noctalia/config.toml (was JSON), and validateConfig
    # (default true) checks them against the real schema at build time.
    programs.noctalia = {
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
              { id = "ScreenRecorder"; }
              { id = "Tray"; }
              { id = "Battery"; }
              { id = "Volume"; }
              {
                id = "Clock";
                formatHorizontal = "HH:mm ddd, MMM dd";
              }
              { id = "ControlCenter"; }
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
