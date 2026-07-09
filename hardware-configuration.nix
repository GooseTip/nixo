{ config, lib, pkgs, modulesPath, ... }:

# NOTE: This is a starting-point placeholder, not your real hardware config.
#
# During install, after `disko` has partitioned and mounted the disk, run:
#   nixos-generate-config --no-filesystems --root /mnt
# This will write a real /mnt/etc/nixos/hardware-configuration.nix with your
# actual detected kernel modules and CPU microcode settings. Copy that file's
# `boot.initrd.availableKernelModules`, `boot.kernelModules`, and
# `hardware.cpu.*` sections in here (filesystems are already handled by
# disko.nix, so you don't need those).
#
# The values below are reasonable defaults for the Ryzen AI 9 HX 375
# (Strix Point) in the OmniBook Ultra 14 and should work out of the box,
# but confirm against the generated file.

{
  imports = [ ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
  ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Strix Point is recent silicon — stay on a current kernel for amdgpu +
  # MediaTek Wi-Fi 7 (MT7925) support.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  nixpkgs.hostPlatform = "x86_64-linux";
}
