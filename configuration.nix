# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      OSCAR
      android-tools
      anki-bin
      audacity
      bc
      bsnes-hd
      cargo
      chromium
      clang
      cockatrice
      deno
      evince
      exiftool
      file
      firefox
      flips
      fzf
      git-annex
      gnome.eog
      htop
      hydra-check
      imagemagick
      libreoffice
      mullvad
      mullvad-vpn
      networkmanagerapplet
      nix-tree
      nixd
      nixpkgs-fmt
      nodePackages.node2nix
      nodejs
      nushell
      pandoc
      parallel
      pavucontrol
      pdftk
      powertop
      pulseaudio
      pv
      python3
      python311Packages.python-lsp-server
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
      steam
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
  };

  fonts.packages = with pkgs; [
    fira-code
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
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
      enabled = "fcitx5";
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
    package = pkgs.nixUnstable;
    settings.allowed-users = [
      "@wheel"
    ];
    extraOptions =
      ''
        extra-experimental-features = auto-allocate-uids ca-derivations configurable-impure-env flakes nix-command repl-flake
      '';
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
    "steam-runtime"
  ];

  programs = {
    fish = {
      enable = true;
      shellAbbrs = {
        diff = "diff --color";
        grep = "rg";
        less = "less -n";
        ls = "ls --color=auto -F --group-directories-first";
        nfu = "nix flake update";
        nrs = "nixos-rebuild switch --use-remote-sudo";
        ps = "ps -eHo 'pid,stime,euser,cmd'";
        ygo = "/home/lexi/ccg/ygo/bin/ygo.mjs";
        ygo-rs = "/home/lexi/repos/ygo/target/release/ygo";
      };
      interactiveShellInit =
        ''
          set -g fish_greeting
        '';
      promptInit =
        ''
          function fish_prompt --description 'Write out the prompt'
            set -l last_status $status
            set -l normal (set_color normal)
            set -l status_color (set_color brgreen)
            set -l cwd_color (set_color $fish_color_cwd)
            set -l vcs_color (set_color brpurple)
            set -l prompt_status ""

            # Since we display the prompt on a new line allow the directory names to be longer.
            set -q fish_prompt_pwd_dir_length
            or set -lx fish_prompt_pwd_dir_length 0

            # Color the prompt differently when we're root
            set -l suffix '❯'
            if functions -q fish_is_root_user; and fish_is_root_user
                if set -q fish_color_cwd_root
                    set cwd_color (set_color $fish_color_cwd_root)
                end
                set suffix '#'
            end

            # Color the prompt in red on error
            if test $last_status -ne 0
                set status_color (set_color $fish_color_error)
                set prompt_status $status_color "[" $last_status "]" $normal
            end

            echo -s (prompt_login) ' ' $cwd_color (prompt_pwd) $vcs_color (fish_vcs_prompt) $normal ' ' $prompt_status
            echo -n -s $status_color $suffix ' ' $normal
          end
        '';
    };

    light.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    ssh = {
      startAgent = true;
    };

    steam.enable = true;
    sway.enable = true;
    xwayland.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true;

    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.sway}/bin/sway";
          user = "lexi";
        };
        default_session = initial_session;
      };
    };

    mullvad-vpn.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    printing.enable = true;

    udev = {
      packages = [ pkgs.android-udev-rules ];
    };

    openssh.enable = true;
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
    extraGroups = [ "video" "wheel" ];
    shell = pkgs.fish;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };
}
