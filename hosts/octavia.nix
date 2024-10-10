{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices.root = {
        allowDiscards = true; # enables TRIM, optional.
        device = "/dev/disk/by-uuid/a60efb6d-c3d0-4eda-8b1b-fa70c43f80ef";
        preLVM = true; # we need to decrypt the physical partition before LVM mounts our logical partitions.
      };
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/4cd47a13-3d33-4ebd-88fb-69ed41195b41";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/56A7-8C95";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/d2270adc-3d73-4e16-ad03-af7e163952e4"; }
  ];

  powerManagement = {
    cpuFreqGovernor = "ondemand";
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  networking = {
    hostName = "octavia";
  };

  services = {
    blueman.enable = true;
    fwupd.enable = true;
  };
}
