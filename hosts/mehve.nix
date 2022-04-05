{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.root = {
        allowDiscards = true;  # enables TRIM, optional.
        device = "/dev/disk/by-uuid/8bb6d73a-0c15-4955-983a-7f02083be96e";
        preLVM = true;  # we need to decrypt the physical partition before LVM mounts our logical partitions.
      };
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/9f4cef70-94e9-4fd5-bf56-132b3a6acd03";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/59D4-DEAB";
      fsType = "vfat";
    };
	};

  swapDevices = [
    { device = "/dev/disk/by-uuid/4fe7822d-9760-4142-a04a-a02988838fab"; }
  ];

  powerManagement = {
    cpuFreqGovernor = "ondemand";
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    sane.enable = true;
  };
}
