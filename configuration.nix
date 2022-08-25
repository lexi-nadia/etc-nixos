# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  environment = {
    shellAliases = {
      diff = "diff --color";
      grep = "rg";
      less = "less -n";
      ls = "ls --color=auto -F --group-directories-first";
      nrs = "nixos-rebuild switch --use-remote-sudo";
      ps = "ps -eHo 'pid,stime,euser,cmd'";
      ygo = "/home/lexi/ccg/ygo/bin/ygo.mjs";
      ygo-rs = "/home/lexi/repos/ygo/target/release/ygo";
    };
    systemPackages = with pkgs; [
      OSCAR
      bc
      cargo
      clang
      cockatrice
      cups-filters
      deno
      (discord.override { nss = nss_latest; })
      evince
      exiftool
      file
      firefox-wayland
      fzf
      git-annex
      gnome.eog
      gnumake
      htop
      imagemagick
      libreoffice
      lutris
      mako
      mullvad
      mullvad-vpn
      networkmanagerapplet
      nixpkgs-fmt
      nodePackages.node2nix
      nodejs-18_x
      nushell
      nvimpager
      pandoc
      parallel
      pavucontrol
      pdftk
      powerline
      pulseaudio
      python3
      ripgrep
      rnix-lsp
      rofi-wayland
      rust-analyzer
      rustc
      rustfmt
      sane-frontends
      scribus
      signal-cli
      signal-desktop
      spotify
      sqlite
      steam
      sumneko-lua-language-server
      sway-contrib.grimshot
      swayidle
      swaylock
      unzip
      waybar
      wezterm
      wget
      wl-clipboard
      zathura
      zsh-autosuggestions
    ];
  };

  fonts.fonts = with pkgs; [
    fira-code
    font-awesome
    roboto
    roboto-mono
    roboto-slab
  ];

  hardware = {
    sane.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.lexi.imports = [ ./users/lexi.nix ];
    users.root.imports = [ ./users/root.nix ];
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    dhcpcd.enable = false;
    useNetworkd = true;

    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp4s0.useDHCP = true;
    };

    networkmanager = {
      enable = true;
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

  # this keeps failing, both the binary and the finality of such state
  # is a fallacy anyway
  systemd.services."systemd-networkd-wait-online".enable = false;

  nix = {
    package = pkgs.nixUnstable;
    settings.allowed-users = [
      "@wheel"
    ];
    extraOptions =
      ''
        extra-experimental-features = nix-command flakes
      '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "spotify"
    "spotify-unwrapped"
    "steam"
    "steam-original"
    "steam-runtime"
  ];

  programs = {

    light.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    ssh = {
      startAgent = true;
    };

    steam = {
      enable = true;
    };

    sway = {
      enable = true;
    };

    zsh = {
      enable = true;
      autosuggestions.enable = true;
      setOptions = lib.mkOptionDefault [
        "AUTO_PUSHD"
        "NO_BEEP"
        "PUSHD_IGNORE_DUPS"
      ];
      promptInit =
        ''
          autoload -U colors && colors && PROMPT="%(?.%?.%{$fg_bold[red]%}%?%{$reset_color%b%}) %{$fg_bold[magenta]%}%n%{$reset_color%b%}@$fg[green]%m%{$reset_color%} %~ %D{%a %b %d %H:%M:%S}
          \$ "
        '';
      interactiveShellInit =
        ''
          bindkey -e
          . /etc/zinputrc
          hash -d nix=/etc/nixos
        '';
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;

    mullvad-vpn.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    printing = {
      enable = true;
    };

    xserver = {
      enable = true;

      displayManager = {
        autoLogin = {
          enable = true;
          user = "lexi";
        };
        gdm.enable = true;
      };
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
    stateVersion = "21.11"; # Did you read the comment?
  };

  time.timeZone = "America/New_York";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lexi = {
    isNormalUser = true;
    extraGroups = [ "video" "wheel" ];
    shell = pkgs.zsh;
  };
}
