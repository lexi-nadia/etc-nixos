# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, pkgs, ... }:

{
  environment = {
    shellAliases = {
      diff = "diff --color";
      grep = "rg";
      jj-sync = "jj sync; jj evolve";
      less = "less -FRX";
      ls = "lsd";
      nfu = "nix flake update";
      nrs = "nixos-rebuild switch --use-remote-sudo";
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
      eog
      evince
      exiftool
      file
      firefox
      fzf
      git-annex
      htop
      hydra-check
      imagemagick
      jujutsu
      libreoffice
      lua-language-server
      networkmanagerapplet
      nix-tree
      nixd
      nixfmt-rfc-style
      nixpkgs-fmt
      nodePackages.node2nix
      nodejs
      pandoc
      parallel
      pavucontrol
      pdftk
      powertop
      pulseaudio
      pv
      python3
      python312Packages.python-lsp-server
      qbittorrent
      retroarch
      ripgrep
      rlwrap
      rofi-wayland
      rust-analyzer
      rustc
      rustfmt
      scribus
      signal-cli
      signal-desktop
      sqlite
      sway-contrib.grimshot
      swayidle
      swaylock
      unzip
      vlc
      waybar
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
    settings.allowed-users = [
      "@wheel"
    ];
    extraOptions = ''
      extra-experimental-features = auto-allocate-uids ca-derivations flakes nix-command no-url-literals
    '';
  };

  programs = {
    adb.enable = true;
    light.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    regreet.enable = true;

    ssh = {
      startAgent = true;
    };

    sway.enable = true;
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

  services = {
    gnome.gnome-keyring.enable = true;

    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "lexi";
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
      pulse.enable = true;
    };

    printing.enable = true;
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
