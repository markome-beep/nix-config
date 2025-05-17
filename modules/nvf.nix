{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    ripgrep
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
            key = "<leader>/";
            mode = "n";
            silent = true;
            expr = ''
              function()
                builtin.live_grep({
                grep_open_files = true,
                prompt_title = "Live Grep in Open Files",
              })'';
          }
        ];

        lsp = {
          formatOnSave = true;
          enable = true;
        };
        languages = {
          enableTreesitter = true;
          enableFormat = true;

          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
          lua.enable = true;
        };
      };
    };
  };
}
