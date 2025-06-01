{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    ripgrep
    fzf
  ];

  programs.nvf = {
    enable = true;

    settings.vim = {
      undoFile.enable = true;
      clipboard = {
        enable = true;
      };
      hideSearchHighlight = true;

      theme = {
        enable = true;
        name = "tokyonight";
        style = "night";
      };

      options = {
        wrap = false;
        tabstop = 4;
      };

      statusline.lualine.enable = true;

      telescope = {
        enable = true;
        mappings = {
          buffers = "<leader><leader>";
        };
      };

      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        mappings = {
          confirm = "<C-y>";
          next = "<C-n>";
          previous = "<C-p>";
        };
      };

      formatter = {
        conform-nvim.enable = true;
      };

      utility = {
        sleuth.enable = true;
        oil-nvim = {
          enable = true;
          setupOpts = {
            view_options.show_hidden = true;
          };
        };
      };

      mini = {
        icons.enable = true;
        surround.enable = true;
      };

      lazy.plugins = {
        undotree = {
          package = pkgs.vimPlugins.undotree;

          cmd = ["UndotreeToggle"];

          keys = [
            {
              mode = "n";
              key = "<leader>u";
              action = "vim.cmd.UndotreeToggle";
              lua = true;
              desc = "Toggle undotree [Undotree]";
            }
          ];
        };
      };

      keymaps = [
        {
          key = "J";
          mode = "v";
          action = ":m '>+1<CR>gv=gv";
        }

        {
          key = "K";
          mode = "v";
          action = ":m '<-2<CR>gv=gv";
        }

        {
          key = "<leader>fe";
          mode = "n";
          action = "<CMD>Oil<CR>";
        }

        {
          key = "<leader>e";
          mode = "n";
          action = "vim.diagnostic.open_float";
          lua = true;
        }

        {
          key = "<leader>y";
          mode = ["n" "v"];
          action = "\"+y";
        }
      ];

      lsp = {
        formatOnSave = true;
        enable = true;
        mappings = {
          renameSymbol = "<leader>rn";
          codeAction = "<leader>ca";
        };
      };

      treesitter.grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        typescript
      ];

      languages = {
        enableTreesitter = true;
        enableFormat = true;

        nix.enable = true;

        css.enable = true;
        html.enable = true;
        ts.enable = true;
        svelte.enable = true;
        tailwind.enable = true;

        go.enable = true;
        rust.enable = true;
        lua.enable = true;
      };
    };
  };
}
