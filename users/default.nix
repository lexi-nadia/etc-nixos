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
      settings = {
        alias = {
          dt = "difftool --tool vimtabdiff --dir-diff";
        };
        "difftool \"vimtabdiff\"" = {
          "cmd" = "vimtabdiff.py $LOCAL $REMOTE";
        };
        init = {
          defaultBranch = "main";
        };
        merge = {
          conflictstyle = "diff3";
        };
        pull = {
          rebase = true;
        };
        user = {
          email = "me@lexibromfield.com";
          name = "lexi bromfield";
        };
      };
    };

    lsd = {
      enable = true;
      settings = {
        date = "+%Y-%m-%d %H:%M:%S";
        sorting = {
          dir-grouping = "first";
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
        dracula-vim
        lazydev-nvim
        nvim-lspconfig
        rust-vim
        vim-better-whitespace
        vim-dirdiff
        vim-html-template-literals
        vim-javascript
        vim-nix
        vim-unimpaired
        vim-wayland-clipboard
      ];
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'
        return {
          color_scheme = 'Dracula',
          font = wezterm.font 'FiraCode Nerd Font',
          font_size = 10.0,
          hide_tab_bar_if_only_one_tab = true,
          xcursor_theme = 'Vanilla-DMZ',
          xcursor_size = 32,
          front_end = "WebGpu",

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

  xsession.preferStatusNotifierItems = true;
}
