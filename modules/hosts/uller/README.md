# uller

Desktop. AMD (AM5, MSI MAG X870E TOMAHAWK WIFI) with an RTX 5070 Ti, dual
booting Windows 11 from a separate disk with its own ESP.

## Boot

Secure Boot is enforced in firmware because Battlefield 6's Javelin anti-cheat
requires it, so systemd-boot is replaced by lanzaboote (`secureBoot`). Key
enrollment is a manual one-time step -- the order is in the comment block at
the top of `modules/features/secure-boot.nix`.

Windows is never chainloaded from the NixOS ESP, so `windowsBoot` is
deliberately not imported -- unlike hodur. Switching to Windows goes through
`custom.rebootToWindows`, which sets the UEFI BootNext variable, or the
firmware boot menu (F11).

Two MSI-specific traps, both of which cost an evening if missed:

- Set `Provision Factory Default keys: Disabled` **before**
  `Delete all Secure Boot variables`, or the firmware re-provisions on the
  next boot and never actually enters Setup Mode.
- Check `Image Execution Policy` is `Deny Execute`. MSI has shipped firmware
  that reports Secure Boot as enabled without enforcing it, and the anti-cheat
  checks the real state.

Always enroll with `sbctl enroll-keys --microsoft`. Beyond Windows Boot
Manager, the 5070 Ti's option ROM is signed with Microsoft's UEFI CA --
without those certificates you can lose display output at POST.

## Disks

One disk is a Windows Dev Drive formatted **ReFS**, which Linux cannot read at
all (no in-tree driver; only Paragon's commercial one). It is deliberately
absent from `_hardware.nix`. Do not try to mount it, and take care with
partitioners -- it presents as unformatted space.

Any shared data disk must be NTFS. Keep the Steam library on ext4/btrfs;
Proton on NTFS breaks on case sensitivity, permissions and symlinks.

## Monitors

Three outputs, the two side panels rotated 90 degrees. Rotation swaps logical
width and height, so `config/niri/hosts/uller.kdl` positions them using the
rotated widths. Changing a transform or scale invalidates every position after
it -- see the comments in that file.

## When hodur's drive is added

Regenerate `_hardware.nix` (or add the `fileSystems` entry by hand) after
installing it. Note that new files must be `git add`ed before nix can see
them: flakes only read git-tracked files.
