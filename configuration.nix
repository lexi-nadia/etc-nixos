# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  environment = {
    shellAliases = {
      grep = "rg";
      ls = "ls --color=auto -F --group-directories-first";
    };
    systemPackages = with pkgs; [
      bc
      discord
      exiftool
      file
      firefox-wayland
      fzf
      git-annex
      htop
      kitty
      mako
      networkmanagerapplet
      nodePackages.node2nix
      nodejs
      pandoc
      parallel
      pavucontrol
      pdftk
      powerline
      ripgrep
      stow
      sway-contrib.grimshot
      swayidle
      swaylock
      waybar
      wget
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

  hardware.pulseaudio.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.aleksandra = { pkgs, ...}: {
      programs = {
        mako = {
          enable = true;
          defaultTimeout = 5000;
          font = "Noto Sans 8";
          extraConfig =
            ''
              [app-name="discord"]
              anchor=bottom-right
            '';
        };
        mercurial = {
          enable = true;
          aliases = {
            vi = "vimdiff";
            vim = "vimdiff";
          };
          userEmail = "me@aleksbromfield.com";
          userName = "aleksandra";
          extraConfig = {
            ui = {
              merge = "vimdiff";
            };
            extensions = {
              "hgext.extdiff" = "";
            };
            extdiff = {
              "cmd.vimdiff" = "";
              "cmd.dirdiff" = "vim";
              "opts.dirdiff" = "-f '+next' '+execute \"DirDiff\" fnameescape(argv(0)) fnameescape(argv(1))'";
            };
            merge-tools = {
              "vimdiff.executable" = "vimdiff";
              "vimdiff.args" = "-f -d $output -M $local $base $other -c \"wincmd J\" -c \"set modifiable\" -c \"set write\"";
              "vimdiff.premerge" = "keep";
            };
          };
        };
      };
      services = {
        network-manager-applet.enable = true;
      };
      wayland = {
        windowManager = {
          sway = {
            enable = true;
            package = null;
            config = {
              modifier = "Mod4";
              terminal = "kitty";
              fonts = {
                names = ["Noto Sans"];
                size = 8.0;
              };
              input = {
                "1:1:AT_Translated_Set_2_keyboard" = {
                  xkb_layout = "us";
                  xkb_variant = "altgr-intl";
                  xkb_options = "caps:swapescape";
                };
                "2:7:SynPS/2_Synaptics_TouchPad" = {
                  natural_scroll = "enabled";
                  scroll_factor = "0.25";
                };
                "10730:258:Kinesis_Advantage2_Keyboard" = {
                  xkb_layout = "us";
                  xkb_variant = "altgr-intl";
                };
              };
              output = {
                eDP-1 = {
                  pos = "1920 120";
                  bg = "$HOME/img/wallpaper.jpg center";
                };
                HDMI-A-1 = {
                  pos = "0 0";
                  bg = "$HOME/img/wallpaper2.jpg fill";
                };
              };
              workspaceOutputAssign = [
                { output = "eDP-1"; workspace = "-1"; }
                { output = "HDMI-A-1"; workspace = "0"; }
              ];
              bars = [
                {
                  position = "top";
                  command = "${pkgs.waybar}/bin/waybar";
                }
              ];
              focus = {
                mouseWarping = false;
              };
              floating = {
                criteria = [
                  { app_id = "xdg-desktop-portal-gtk"; }
                  { app_id = "eog"; }
                  { app_id = "^$"; }
                ];
              };
              window = {
                titlebar = true;
              };
              keybindings = let
                modifier = "Mod4";
              in lib.mkOptionDefault {
                "${modifier}+Shift+Return" = "exec firefox";
                "${modifier}+z" = "exec swaylock -f -c 000000";
                "${modifier}+Shift+z" = "exec systemctl suspend";

                # Adjust volume
                "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +10%";
                "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -10%";
                "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
                "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
                 
                # Adjust screen brightness
                "XF86MonBrightnessUp" = "exec light -A 5";
                "XF86MonBrightnessDown" = "exec light -U 5";
                 
                # Take a screenshot
                "${modifier}+p" = "exec grimshot save active";
                "${modifier}+Shift+p" = "exec grimshot save area";
                "${modifier}+Mod1+p" = "exec grimshot save output";
                "${modifier}+Ctrl+p" = "exec grimshot save window";
              };
              startup = [
                { command = "nm-applet --indicator"; always = true; }
                { command = "mako"; always = true; }
                { command = "makoctl reload"; always = true; }
              ];
            };
            extraConfig =
              ''
                for_window [shell=".*"] title_format "%title :: %shell"
              '';
          };
        };
      };
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "mehve";
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
  ];

  programs = {
    git = {
      enable = true;
      config = {
        user = {
          email = "me@aleksbromfield.com";
          name = "aleksandra bromfield";
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
        customRC ="lua << EOF\n" + (builtins.readFile /home/aleksandra/.config/nvim/init.lua) + "EOF\n";
        packages.nix.start = with pkgs.vimPlugins; [
          async-vim
          dracula-vim
          nvim-lspconfig
          rust-vim
          vim-dirdiff
          vim-html-template-literals
          vim-javascript
          vim-lsp
          vim-unimpaired
        ];
      };
    };

    ssh = {
      startAgent = true;
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
      promptInit = "autoload -U colors && colors && PROMPT=\"%(?.%?.%{$fg_bold[red]%}%?%{$reset_color%b%}) %{$fg_bold[magenta]%}%n%{$reset_color%b%}@$fg[green]%m%{$reset_color%} %~ %D{%a %b %d %H:%M:%S}
\$ \"";
      setOptions = [
        "AUTO_PUSHD"
        "HIST_FCNTL_LOCK"
        "HIST_IGNORE_DUPS"
        "NO_BEEP"
        "PUSHD_IGNORE_DUPS"
        "SHARE_HISTORY"
      ];
    };
  };

  services = {
    printing = {
      enable = true;
    };

    xserver = {
      enable = true;

      displayManager = {
        autoLogin = {
          enable = true;
          user = "aleksandra";
        };
        gdm.enable = true;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
  };

  sound.enable = true;

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
  users.users.aleksandra = {
    isNormalUser = true;
    extraGroups = [ "video" "wheel" ];
    shell = pkgs.zsh;
  };
}
