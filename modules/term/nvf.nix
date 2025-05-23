{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    ripgrep
    fzf
  ];

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        undoFile.enable = true;

        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };

        options = {
          wrap = false;
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
          oil-nvim.enable = true;
        };

        mini = {
          icons.enable = true;
        };

        keymaps = [
          {
            key = "J";
            mode = "v";
            silent = true;
            action = ":m '>+1<CR>gv=gv";
          }

          {
            key = "K";
            mode = "v";
            silent = true;
            action = ":m '<-2<CR>gv=gv";
          }

          {
            key = "<leader>fe";
            mode = "n";
            silent = true;
            action = "<CMD>Oil<CR>";
          }

          {
            key = "<leader>e";
            mode = "n";
            silent = true;
            action = "vim.diagnostic.open_float";
            lua = true;
          }
        ];

        lsp = {
          formatOnSave = true;
          enable = true;
          mappings = {
            renameSymbole = "<leader>rn";
            codeAction = "<leader>ca";
          };
        };

        languages = {
          enableTreesitter = true;
          enableFormat = true;

          nix.enable = true;
          go.enable = true;
          ts.enable = true;
          rust.enable = true;
          lua.enable = true;
        };
      };
    };
  };
}
