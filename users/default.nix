{ lib, pkgs, ... }:

{
  home = {
    stateVersion = "26.05";
  };

  programs = {
    difftastic = {
      enable = true;
      git.enable = true;
      jujutsu.enable = true;
    };

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

    jujutsu = {
      enable = true;
      settings = {
        name = "Lexi Bromfield";
        email = "me@lexibromfield.com";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        catppuccin-nvim
        nvim-lspconfig
				nvim-treesitter.withAllGrammars
        rustaceanvim
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
        vim.lsp.enable('emmylua_ls')
        vim.lsp.enable('nixd')
        vim.lsp.enable('pyrefly')
        vim.lsp.enable('ruff')
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
        vim.g.strip_whitespace_on_save = true
        vim.g.strip_whitespace_confirm = false
        vim.g.strip_whitelines_at_eof = true
        vim.g.rustfmt_autosave = true
        vim.g.markdown_fenced_languages = {
          "ts=typescript"
        }

        vim.api.nvim_command([[autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif]])
        vim.api.nvim_command('colorscheme catppuccin-mocha')

        -- Jump to the last position.
        vim.api.nvim_command([[autocmd BufReadPost * if line2byte(line("$") + 1) <= 1000000 && line("'\"") >= 1 && line("'\"") <= line("$") | execute 'normal! g`"' | endif]])

        vim.api.nvim_set_keymap('n', 'tn', [[:tabnew<CR>]], { noremap = true })
        vim.api.nvim_set_keymap('n', 'tt', [[:tabedit ]], { noremap = true })
      '';
    };

    opencode = {
      enable = true;
      web.enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    vicinae = {
      enable = true;
      systemd.enable = true;
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'
        return {
          color_scheme = 'catppuccin-mocha',
          font = wezterm.font 'FiraCode Nerd Font',
          font_size = 10.0,
          hide_tab_bar_if_only_one_tab = true,
          xcursor_theme = 'Vanilla-DMZ',
          xcursor_size = 32,
          front_end = "WebGpu",

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

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      setOptions = lib.mkOptionDefault [
        "AUTO_PUSHD"
        "NO_BEEP"
        "PUSHD_IGNORE_DUPS"
      ];
      initContent = ''
        bindkey -e
        . /etc/zinputrc
        hash -d nix=/etc/nixos
      '';
    };
  };

  services = {
    awww = {
      enable = true;
    };

    wayle = {
      enable = true;
    };
  };

  xsession.preferStatusNotifierItems = true;
}
