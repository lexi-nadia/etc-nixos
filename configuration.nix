# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "discord-unwrapped"
    "steam"
    "steam-unwrapped"
    "zoom-us"
    "zoom"
  ];

  nixpkgs.overlays = [ (final: prev: {
    inherit (final.lixPackageSets.stable)
      nixpkgs-review
      nix-direnv
      nix-eval-jobs
      nix-fast-build
      colmena;
  }) ];

  boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "6.18.22") (
    lib.mkDefault pkgs.linuxPackages_6_18
  );

  environment = {
    shellAliases = {
      diff = "diff --color";
      grep = "rg";
      jj-sync = "jj sync; jj evolve";
      less = "less -FRX";
      ls = "lsd";
      nfu = "nix flake update";
      nrs = "nixos-rebuild switch --sudo --keep-going";
      ps = "ps -eHo 'pid,stime,euser,cmd'";
    };
    systemPackages = with pkgs; [
      android-tools
      anki-bin
      audacity
      bottom
      broot
      cargo
      choose
      chromium
      clang
      cockatrice
      deno
      discord
      dua
      dust
      element-desktop
      exiftool
      fd
      fend
      file
      firefox
      fzf
      git-annex
      gnupg
      hck
      hexyl
      huniq
      hydra-check
      jujutsu
      kalker
      libreoffice
      lua-language-server
      miro
      nix-tree
      nixd
      nixfmt
      nixpkgs-fmt
      nodejs
      oculante
      olympus
      oscar
      ouch
      pandoc
      #pdf-oxide
      procs
      pyrefly
      (python3.withPackages (ps: with ps; [
        z3-solver
      ]))
      qbittorrent
      retroarch
      ripgrep
      rlwrap
      rnr
      rust-analyzer
      rust-parallel
      rustc
      rustfmt
      sad
      sbctl
      scribus
      sd
      signal-cli
      signal-desktop
      skim
      sqlite
      tailspin
      tdf
      tealdeer
      uutils-coreutils
      vlc
      vscodium
      wezterm
      wl-clipboard-rs
      xcp
      xh
      zoom-us
    ];

    variables = {
      PAGER = "less -FRX";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.noto
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    roboto
    roboto-mono
    roboto-slab
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.lexi.imports = [ ./users/lexi.nix ];
    users.root.imports = [ ./users/root.nix ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-mozc
      ];
    };
  };

  networking = {
    dhcpcd.enable = false;
    networkmanager.enable = true;
  };

  systemd = {
    network = {
      enable = true;
      wait-online.enable = false;
    };
  };

  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    settings.allowed-users = [
      "@wheel"
    ];
    extraOptions = ''
      extra-experimental-features = auto-allocate-uids flakes nix-command
    '';
  };

  programs = {
    bat.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    niri.enable = true;
    noisetorch.enable = true;
    steam.enable = true;
    xwayland.enable = true;
    zoxide.enable = true;
    zsh.enable = true;
  };

  security = {
    pam = {
      u2f = {
        enable = true;
        settings = {
          cue = true;
        };
      };
    };
    rtkit = {
      enable = true;
    };
    sudo = {
      enable = false;
    };
    sudo-rs = {
      enable = true;
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };

    displayManager = {
      regreet = {
        enable = true;
      };
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [ hplip ];
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "22.11"; # Did you read the comment?
  };

  time.timeZone = "America/New_York";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lexi = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
