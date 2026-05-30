# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "steam"
    "steam-unwrapped"
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
      oscar
      anki-bin
      audacity
      bc
      cargo
      chromium
      clang
      cockatrice
      deno
      discord
      element-desktop
      eog
      evince
      exiftool
      file
      firefox
      fzf
      git-annex
      gnupg
      htop
      hydra-check
      imagemagick
      jujutsu
      kdePackages.kcalc
      kdePackages.kcharselect
      kdePackages.kclock
      kdePackages.kcolorchooser
      kdePackages.kgpg
      kdePackages.kolourpaint
      kdePackages.ksystemlog
      kdePackages.partitionmanager
      kdePackages.sddm-kcm
      libreoffice
      lua-language-server
      nix-tree
      nixd
      nixfmt-rfc-style
      nixpkgs-fmt
      nodePackages.node2nix
      nodejs
      olympus
      pandoc
      parallel
      pavucontrol
      pdftk
      pipx
      powertop
      pulseaudio
      pv
      pyrefly
      python3
      python312Packages.python-lsp-server
      qbittorrent
      retroarch
      ripgrep
      rlwrap
      rust-analyzer
      rustc
      rustfmt
      sbctl
      scribus
      signal-cli
      signal-desktop
      sqlite
      unzip
      vlc
      wezterm
      wl-clipboard
      zathura
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
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
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
      extra-experimental-features = auto-allocate-uids flakes nix-command no-url-literals
    '';
  };

  programs = {
    adb.enable = true;
    light.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    noisetorch.enable = true;

    regreet.enable = true;

    ssh = {
      startAgent = true;
    };

    steam.enable = true;

    xwayland.enable = true;

    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      setOptions = lib.mkOptionDefault [
        "AUTO_PUSHD"
        "NO_BEEP"
        "PUSHD_IGNORE_DUPS"
      ];
      promptInit = ''
        autoload -U colors && colors && PROMPT="%(?.%?.%{$fg_bold[red]%}%?%{$reset_color%b%}) %{$fg_bold[magenta]%}%n%{$reset_color%b%}@$fg[green]%m%{$reset_color%} %~ %D{%a %b %d %H:%M:%S}
        \$ "
      '';
      interactiveShellInit = ''
        bindkey -e
        . /etc/zinputrc
        hash -d nix=/etc/nixos
      '';
    };
  };

  security = {
    rtkit = {
      enable = true;
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
    };

    desktopManager = {
      plasma6 = {
        enable = true;
      };
    };

    displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
      };
    };

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
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
