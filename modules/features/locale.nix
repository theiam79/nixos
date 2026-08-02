{ ... }:
{
  flake.nixosModules.locale = {
    time.timeZone = "America/Chicago";

    # Both hosts dual-boot Windows, which writes local time to the RTC.
    # Without this the clocks disagree by the UTC offset after each switch.
    time.hardwareClockInLocalTime = true;
  };
}
