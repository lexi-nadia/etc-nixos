{ lib, pkgs, ... }:

{
  home = {
    stateVersion = "23.05";
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
      withPython3 = false;
      withRuby = false;
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
      initLua = ''
        -- Mappings.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions.
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
        vim.keymap.set("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

        vim.lsp.enable('denols')
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('nixd')
        vim.lsp.enable('pyrefly')
        vim.lsp.enable('rust_analyzer')

        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.termguicolors = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 0
        vim.opt.autochdir = true
        vim.opt.matchpairs = '(:),{:},[:],<:>'
        vim.opt.foldmethod = 'syntax'
        vim.opt.foldenable = false
        vim.opt.modeline = false -- for security
        vim.opt.scrolloff = 3
        vim.opt.sidescrolloff = 30
        vim.g.loaded_perl_provider = false
        vim.g.dracula_colorterm = false
        vim.g.strip_whitespace_on_save = true
        vim.g.strip_whitespace_confirm = false
        vim.g.strip_whitelines_at_eof = true
        vim.g.rustfmt_autosave = true
        vim.g.markdown_fenced_languages = {
          "ts=typescript"
        }

        vim.api.nvim_command([[autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif]])
        vim.api.nvim_command('colorscheme dracula')

        -- Jump to the last position.
        vim.api.nvim_command([[autocmd BufReadPost * if line2byte(line("$") + 1) <= 1000000 && line("'\"") >= 1 && line("'\"") <= line("$") | execute 'normal! g`"' | endif]])

        vim.api.nvim_set_keymap('n', 'tn', [[:tabnew<CR>]], { noremap = true })
        vim.api.nvim_set_keymap('n', 'tt', [[:tabedit ]], { noremap = true })
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
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
