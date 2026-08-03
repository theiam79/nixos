{ ... }:
{
  # Compressed swap in RAM. No swap device was configured at all, which means
  # memory pressure goes straight to the OOM killer with no warning -- bad on
  # a box running Steam, a Talos toolchain and sandboxed builds at once.
  #
  # zram rather than a swapfile or partition: it costs no disk, only allocates
  # as it fills, and backs onto RAM so paging out is cheap. Note it rules out
  # hibernation, which needs a real swap device -- not wanted here anyway.
  flake.nixosModules.zram = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    # Defaults are tuned for spinning-rust swap and leave zram badly
    # underused. These are the well-worn zram values (Fedora/ChromeOS).
    boot.kernel.sysctl = {
      # Swapping to RAM is cheap, so do it readily rather than as a last resort.
      "vm.swappiness" = 180;
      # No seek penalty, so swap readahead only wastes work.
      "vm.page-cluster" = 0;
      # Start reclaiming earlier, and do not inflate the gap after a stall.
      "vm.watermark_scale_factor" = 125;
      "vm.watermark_boost_factor" = 0;
    };
  };
}
