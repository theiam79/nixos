{ ... }:
{
  # RGB control. SignalRGB is Windows-only, so OpenRGB is the Linux
  # equivalent -- narrower device coverage, but it handles what is here:
  # Corsair DDR5 RGB over SMBus, and the Lian Li Uni Hub (Lian Li now ship an
  # official L-Connect 3 x OpenRGB beta).
  #
  # `motherboard = "amd"` is what makes RAM and motherboard lighting work: it
  # loads i2c-piix4 alongside i2c-dev so the SMBus controller is reachable.
  # Intel boards want "intel" (i2c-i801) instead.
  #
  # The service runs as root and owns the hardware; the GUI talks to it over
  # localhost:6742. That avoids needing the user in the `i2c` group -- add
  # tyler to it only if something needs to poke SMBus directly.
  #
  # Enumerate what is actually detected with:
  #   openrgb --list-devices
  flake.nixosModules.rgb = { pkgs, ... }: {
    services.hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    hardware.i2c.enable = true;

    # The service installs the udev rules; the package is what gives you the
    # GUI and CLI.
    environment.systemPackages = [ pkgs.openrgb ];
  };
}
