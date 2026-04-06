{
  pkgs,
  lib,
  ...
}:
{
  config.vim = {
    undoFile.enable = true;
    hideSearchHighlight = true;
    spellcheck.enable = true;

    theme = {
      enable = true;
      name = "tokyonight";
      style = "night";
    };

    options = {
      wrap = false;
      tabstop = 4;
      termguicolors = true;
    };

    luaConfigPre = ''
      vim.opt.scrolloff = 16
    '';

    statusline.lualine.enable = true;

    telescope = {
      enable = true;
      mappings = {
        buffers = "<leader><leader>";
      };
    };

    autocomplete = {
      blink-cmp = {
        enable = true;
        friendly-snippets.enable = true;
        mappings = {
          confirm = "<C-y>";
          next = "<C-n>";
          previous = "<C-p>";
        };
        # ----- OR -------
        # nvim-cmp = {
        #   enable = true;
        #   mappings = {
        #     confirm = "<C-y>";
        #     next = "<C-n>";
        #     previous = "<C-p>";
        #   };
        # };
      };
    };

    # assistant.copilot = {
    #   enable = true;
    #   cmp.enable = true;
    # };
    
    assistant.supermaven-nvim.enable = true;

    utility = {
      sleuth.enable = true;

      oil-nvim = {
        enable = true;
        setupOpts = {
          view_options.show_hidden = true;
        };
      };

      undotree.enable = true;
    };

    mini = {
      icons.enable = true;
      surround.enable = true;
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
        key = "<leader>/";
        mode = "n";
        action = ''
          function()
            require("telescope.builtin").current_buffer_fuzzy_find()
          end
        '';
        lua = true;
      }

      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>y";
        action = "\"+y";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>u";
        action = "<CMD>UndotreeToggle<CR>";
      }
    ];

    augroups = [
      {
        name = "YankHighlight";
        clear = true;
      }
    ];

    autocmds = [
      {
        event = [ "TextYankPost" ];
        desc = "Highlight on yank";

        callback = lib.generators.mkLuaInline ''
          function()
            vim.highlight.on_yank()
          end
        '';

        pattern = [ "*" ];
        group = "YankHighlight";
      }
    ];

    lsp = {
      enable = true;
      mappings = {
        renameSymbol = "<leader>rn";
        codeAction = "<leader>ca";
        goToDefinition = "<leader>gd";
      };
    };

    treesitter = {
      enable = true;
      # fold = true;
      autotagHtml = true;
      indent.enable = true;

      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        templ
      ];
    };

    languages = {
      # General Settings
      enableTreesitter = true;
      enableFormat = true;

      # Nix
      nix.enable = true;

      # Web Development
      css.enable = true;
      html.enable = true;
      ts.enable = true;
      svelte.enable = true;
      tailwind.enable = true;

      # Other Languages
      qml.enable = true;
      go.enable = true;
      rust.enable = true;
      lua.enable = true;
      bash.enable = true;
      clang.enable = true;
      yaml.enable = true;
      ruby.enable = true;
      python.enable = true;
    };
  };
}
