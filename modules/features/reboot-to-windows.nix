{ ... }:
{
  # One-shot reboot into Windows by setting the UEFI BootNext variable.
  #
  # Windows boots through its own firmware entry, so nothing is copied and the
  # measured boot path is unchanged -- unlike chainloading a mirrored
  # bootloader. Going the other way needs nothing: NixOS stays first in
  # BootOrder, so a normal reboot from Windows lands back here.
  flake.nixosModules.rebootToWindows = { config, lib, pkgs, ... }:
    let
      cfg = config.custom.rebootToWindows;
    in
    {
      options.custom.rebootToWindows = {
        enable = lib.mkEnableOption "the reboot-to-windows helper";

        entryLabel = lib.mkOption {
          type = lib.types.str;
          default = "Windows Boot Manager";
          description = "Label of the UEFI boot entry to target, as shown by efibootmgr.";
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [
          (pkgs.writeShellApplication {
            name = "reboot-to-windows";
            runtimeInputs = with pkgs; [ efibootmgr systemd ];
            text = ''
              label=${lib.escapeShellArg cfg.entryLabel}

              entry=$(efibootmgr \
                | sed -n "s/^Boot\([0-9A-Fa-f]\{4\}\)\*\?  *$label.*/\1/p" \
                | head -n1)

              if [ -z "$entry" ]; then
                echo "No UEFI boot entry matching '$label'. Available entries:" >&2
                efibootmgr >&2
                exit 1
              fi

              echo "Setting BootNext to $entry ($label) and rebooting..."
              sudo efibootmgr --bootnext "$entry" >/dev/null
              systemctl reboot
            '';
          })
        ];
      };
    };
}
