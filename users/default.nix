{ lib, pkgs, ...}:

{
  programs = {
    kitty = {
      enable = true;
      font.name = "Fira Code";
      theme = "Dracula";
      settings = {
        copy_on_select = "clipboard";
        tab_title_template = "{index}: {title}";
      };
    };

    mako = {
      enable = true;
      defaultTimeout = 10000;
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
    
    waybar = {
      enable = true;
      style = ../waybar/style.css;
      settings = {
        mainBar = {
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
              format-icons = ["" "" ""];
          };

          backlight = {
              format = "{percent}% {icon}";
              format-icons = ["" ""];
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
              format-icons = ["" "" "" "" ""];
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
                  headphone = "";
                  hands-free = "";
                  headset = "";
                  phone = "";
                  portable = "";
                  car = "";
                  default = ["" "" ""];
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
                  default = ["" "" ""];
              };
              on-click = "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
              on-click-right = "pavucontrol -t 2";
              on-scroll-up = "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ +1%";
              on-scroll-down = "${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ -1%";
          };
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
}
