{ lib, pkgs, ... }:

{
  home = {
    stateVersion = "23.05";

    file = {
      ".config/nvim/init.lua" = {
        source = ../nvim.lua;
      };
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "lexi bromfield";
      userEmail = "me@lexibromfield.com";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        merge = {
          conflictstyle = "diff3";
        };
        pull = {
          rebase = true;
        };
      };
    };

    mercurial = {
      enable = true;
      aliases = {
        vi = "vimdiff";
        vim = "vimdiff";
      };
      userEmail = "me@lexibromfield.com";
      userName = "lexi";
      extraConfig = {
        ui = {
          merge = "vimdiff";
        };
        extensions = {
          "beautifygraph" = "";
          "hgext.extdiff" = "";
        };
        extdiff = {
          "cmd.vimdiff" = "${pkgs.neovim}/bin/nvim";
          "opts.vimdiff" = "-d";
          "cmd.dirdiff" = "${pkgs.neovim}/bin/nvim";
          "opts.dirdiff" = "-f '+next' '+execute \"DirDiff\" fnameescape(argv(0)) fnameescape(argv(1))'";
        };
        merge-tools = {
          "vimdiff.executable" = "${pkgs.neovim}/bin/nvim";
          "vimdiff.args" = ''-f -d $output -M $local $base $other -c "wincmd J" -c "set modifiable" -c "set write"'';
          "vimdiff.premerge" = "keep";
        };
        experimental = {
          "revisions.prefixhexnode" = "yes";
        };
        color = {
          "changeset.shortest" = "bold underline cyan";
        };
        alias = {
          pvimdiff = "vimdiff -r .~1";
        };
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        #async-vim
        dracula-vim
        nvim-lspconfig
        rust-vim
        vim-better-whitespace
        vim-dirdiff
        vim-html-template-literals
        vim-javascript
        #vim-lsp
        vim-nix
        vim-unimpaired
        vim-wayland-clipboard
      ];
      #extraConfig = "lua << EOF\n" + (builtins.readFile ../nvim.lua) + "EOF\n";
    };

    rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.wezterm}/bin/wezterm";
      theme = "solarized_alternate";
      extraConfig = {
        modi = "run,drun,ssh";
      };
    };

    waybar = {
      enable = true;
      style = ../waybar-style.css;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
          modules-right = [ "idle_inhibitor" "pulseaudio#out" "pulseaudio#in" "network" "cpu" "memory" "temperature" "backlight" "keyboard-state" "sway/language" "battery" "tray" "clock" ];

          keyboard-state = {
            numlock = true;
            capslock = true;
            format = "{name} {icon}";
            format-icons = {
              locked = "";
              unlocked = "";
            };
          };

          "sway/workspaces" = {
            all-outputs = true;
          };

          "sway/mode" = {
            format = "<span style=\"italic\">{}</span>";
          };

          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
          };

          tray = {
            spacing = 10;
            show-passive-items = true;
          };

          clock = {
            format = "{:%Y-%m-%d %H:%M}";
            tooltip = false;
          };

          cpu = {
            format = "{usage}% ";
            tooltip = false;
          };

          memory = {
            format = "{}% ";
          };

          temperature = {
            critical-threshold = 80;
            format = "{temperatureC}°C {icon}";
            format-icons = [ "" "" "" ];
          };

          backlight = {
            format = "{percent}% {icon}";
            format-icons = [ "" "" ];
            on-scroll-up = "light -A 1";
            on-scroll-down = "light -U 1";
          };

          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-charging = "{capacity}% ";
            format-not-charging = "{capacity}% ";
            format-not = "{capacity}% ";
            format-full = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = [ "" "" "" "" "" ];
          };

          network = {
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "{ifname}: {ipaddr}/{cidr} ";
            format-linked = "{ifname} (No IP) ";
            format-disconnected = "Disconnected ⚠";
            format-alt = "{ifname}: {ipaddr}/{cidr}";
          };

          "pulseaudio#out" = {
            format = "{volume}% {icon}";
            format-bluetooth = "{volume}% {icon}";
            format-bluetooth-muted = " {icon}";
            format-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            on-click-right = "pavucontrol -t 1";
          };

          "pulseaudio#in" = {
            format = "{format_source}";
            format-bluetooth = "{format_source}";
            format-bluetooth-muted = "{format_source}";
            format-muted = "{format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            on-click-right = "pavucontrol -t 2";
            on-scroll-up = "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +1%";
            on-scroll-down = "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -1%";
          };
        };
      };
    };

    wezterm = {
      enable = true;
      extraConfig =
        ''
          local wezterm = require 'wezterm'
          return {
            color_scheme = 'Dracula',
            font = wezterm.font 'Fira Code',
            font_size = 10.0 ,
            hide_tab_bar_if_only_one_tab = true;
            xcursor_theme = 'Vanilla-DMZ',
            xcursor_size = 32,

            hyperlink_rules = {
              {
                regex = [[\b(http|https)://[\w.-]+\S*\b]],
                format = '$0',
              },
            },

            mouse_bindings = {
              -- Change the default click behavior so that it only selects
              -- text and doesn't open hyperlinks
              {
                event = { Up = { streak = 1, button = 'Left' } },
                mods = 'NONE',
                action = wezterm.action.CompleteSelection 'PrimarySelection',
              },

              -- and make CTRL-Click open hyperlinks
              {
                event = { Up = { streak = 1, button = 'Left' } },
                mods = 'CTRL',
                action = wezterm.action.OpenLinkAtMouseCursor,
              },

              -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
              {
                event = { Down = { streak = 1, button = 'Left' } },
                mods = 'CTRL',
                action = wezterm.action.Nop,
              },
            },
          }
        '';
    };

  };

  services = {
    mako = {
      enable = true;
      defaultTimeout = 10000;
      font = "Noto Sans 8";
      # https://github.com/altercation/solarized#the-values
      backgroundColor = "#002B36";
      textColor = "#839496";
      borderColor = "#073642";
      extraConfig =
        ''
          [urgency=high]
          text-color=#CB4B16

          [app-name="discord"]
          anchor=bottom-right
        '';
    };

    network-manager-applet.enable = true;
  };

  systemd = {
    user = {
      services = {
        mako = {
          Unit = {
            Description = "Mako notification daemon";
            PartOf = [ "graphical-session.target" ];
          };
          Install = {
            WantedBy = [ "sway-session.target" ];
          };
          Service = {
            Type = "dbus";
            BusName = "org.freedesktop.Notifications";
            ExecStart = "${pkgs.mako}/bin/mako";
            Restart = "always";
            RestartSec = 5;
          };
        };
      };
    };
  };

  wayland = {
    windowManager = {
      sway = {
        enable = true;
        package = null;
        systemd = {
          enable = true;
        };
        config = {
          modifier = "Mod4";
          terminal = "${pkgs.wezterm}/bin/wezterm";
          fonts = {
            names = [ "Noto Sans" ];
            size = 11.0;
          };
          input = {
            "type:keyboard" = {
              xkb_layout = "us";
              xkb_variant = "altgr-intl";
            };
            "type:touchpad" = {
              natural_scroll = "enabled";
            };
            "1:1:AT_Translated_Set_2_keyboard" = {
              xkb_options = "caps:swapescape";
            };
          };
          output = {
            eDP-1 = {
              #pos = "1920 120";
              pos = "0 0";
              bg = "$HOME/img/wallpaper.jpg center";
            };
            "Acer Technologies Acer XFA240 0x0000F386" = {
              pos = "0 0";
              bg = "$HOME/img/wallpaper2.jpg fill";
            };
            "Acer Technologies Acer XFA240 0x00009392" = {
              pos = "1920 0";
              bg = "$HOME/img/wallpaper.jpg center";
            };
          };
          #workspaceOutputAssign = [
          #  { output = "eDP-1"; workspace = "-1"; }
          #  { output = "DP-1"; workspace = "-2"; }
          #  { output = "DP-2"; workspace = "-3"; }
          #];
          bars = [
            {
              position = "top";
              command = "${pkgs.waybar}/bin/waybar";
            }
          ];
          focus = {
            followMouse = false;
            mouseWarping = false;
          };
          floating = {
            criteria = [
              { app_id = "xdg-desktop-portal-gtk"; }
              { app_id = "eog"; }
              { app_id = "^$"; }
              { title = "^Picture in picture$"; }
              { title = "Firefox — Sharing Indicator"; }
            ];
          };
          menu = "${pkgs.rofi-wayland}/bin/rofi -show run";
          window = {
            commands = [
              {
                criteria = { shell = ".*"; };
                command = ''title_format "%title :: %shell"'';
              }
              {
                criteria = { title = "^Picture in picture$"; };
                command = "sticky enable";
              }
              {
                criteria = { title = "nm-tray"; };
                command = "floating disable";
              }
            ];
          };
          keybindings =
            let
              modifier = "Mod4";
              terminal = "${pkgs.wezterm}/bin/wezterm";
            in
            lib.mkOptionDefault {
              "${modifier}+Shift+Return" = "exec ${pkgs.firefox}/bin/firefox";
              "${modifier}+z" = "exec ${pkgs.swaylock}/bin/swaylock -f -c 000000";
              "${modifier}+Shift+z" = "exec ${pkgs.systemd}/bin/systemctl suspend";

              # Override workspace switch keys to maintain separate workspaces
              "${modifier}+1" = "[workspace=1] move workspace to output current; workspace number 1";
              "${modifier}+2" = "[workspace=2] move workspace to output current; workspace number 2";
              "${modifier}+3" = "[workspace=3] move workspace to output current; workspace number 3";
              "${modifier}+4" = "[workspace=1] move workspace to output current; workspace number 4";
              "${modifier}+5" = "[workspace=5] move workspace to output current; workspace number 5";
              "${modifier}+6" = "[workspace=6] move workspace to output current; workspace number 6";
              "${modifier}+7" = "[workspace=7] move workspace to output current; workspace number 7";
              "${modifier}+8" = "[workspace=8] move workspace to output current; workspace number 8";
              "${modifier}+9" = "[workspace=9] move workspace to output current; workspace number 9";
              "${modifier}+0" = "[workspace=10] move workspace to output current; workspace number 10";

              # Focus the other output
              "${modifier}+bracketleft" = "focus output left";
              "${modifier}+bracketright" = "focus output right";

              # Toggle stickiness
              "${modifier}+Shift+s" = "sticky toggle";

              # Adjust volume
              "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +10%";
              "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -10%";
              "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

              # Adjust screen brightness
              "XF86MonBrightnessUp" = "exec ${pkgs.light}/bin/light -A 5";
              "XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 5";

              # Take a screenshot
              "${modifier}+p" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save active";
              "${modifier}+Shift+p" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save area";
              "${modifier}+Mod1+p" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save output";
              "${modifier}+Ctrl+p" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot save window";
            };
          startup = [
            { command = "nm-applet --indicator"; always = true; }
          ];
        };
      };
    };
  };

  xsession.preferStatusNotifierItems = true;
}
