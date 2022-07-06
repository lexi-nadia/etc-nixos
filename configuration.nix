# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  environment = {
    shellAliases = {
      grep = "rg";
      icat = "kitty +kitten icat";
      ls = "ls --color=auto -F --group-directories-first";
      nrs = "nixos-rebuild switch --use-remote-sudo";
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
      discord
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
      kitty
      libreoffice
      mako
      mullvad
      mullvad-vpn
      networkmanagerapplet
      nodePackages.node2nix
      nodejs-18_x
      nushell
      pandoc
      parallel
      pavucontrol
      pdftk
      powerline
      proton-caller
      pulseaudio
      python3
      ripgrep
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
      sway-contrib.grimshot
      swayidle
      swaylock
      unzip
      waybar
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
    git = {
      enable = true;
      config = {
        user = {
          email = "me@lexibromfield.com";
          name = "lexi bromfield";
        };
        init = {
          defaultBranch = "main";
        };
        merge = {
          conflictstyle = "diff3";
        };
      };
    };

    light.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC ="lua << EOF\n" + (builtins.readFile ./nvim.lua) + "EOF\n";
        packages.nix.start = with pkgs.vimPlugins; [
          async-vim
          dracula-vim
          nvim-lspconfig
          rust-vim
          vim-dirdiff
          vim-html-template-literals
          vim-javascript
          vim-lsp
          vim-nix
          vim-unimpaired
        ];
      };
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

    tmux = {
      enable = true;
      aggressiveResize = true;
      baseIndex = 1;
      clock24 = true;
      escapeTime = 10;
      historyLimit = 131072;
      newSession = true;
      shortcut = "a";
      terminal = "tmux-256color";
      plugins = with pkgs.tmuxPlugins; [
        sensible
      ];
      extraConfig =
        ''
          set -g set-titles on
          set -g set-titles-string "#h - #I:#W"
          bind-key C-d kill-window \; detach
          set-option -g renumber-windows on
          set -g @dracula-plugins "battery network"
          set -g @dracula-show-powerline true
          set -g @dracula-military-time true 
          set -g @dracula-show-left-icon 💙
          run-shell ${pkgs.tmuxPlugins.dracula}/share/tmux-plugins/dracula/dracula.tmux
        '';
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
