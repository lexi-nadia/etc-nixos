{
  ...
}:

{
  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [
        "dm-snapshot"
      ];
      luks.devices.root = {
        allowDiscards = true; # enables TRIM, optional.
        device = "/dev/disk/by-uuid/cc36d4e6-9d18-4d81-9dc2-ad81118d42bd";
      };
    };
    kernelModules = [
      "kvm-intel"
    ];
    loader = {
      timeout = 15;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        windows."windows" = {
          title = "Windows";
          efiDeviceHandle = "HD0b";
          sortKey = "z0";
        };
        edk2-uefi-shell = {
          enable = true;
          sortKey = "z1";
        };
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/b9d54351-eb82-439b-9e49-9008d8f80264";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/B515-8832";
      fsType = "vfat";
    };
  };

  hardware = {
    bluetooth.enable = true;
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  networking = {
    hostName = "umi";
  };

  powerManagement = {
    cpuFreqGovernor = "ondemand";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/1d2005c7-6f48-4cc5-956a-8d33ff652852"; }
  ];
}
