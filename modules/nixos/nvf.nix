{
  inputs,
  pkgs,
  ...
}: {
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        theme = {
          enable = true;
          name = "tokyonight";
          style = "night";
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.blink-cmp.enable = true;
        formatter = {
          conform-nvim.enable = true;
        };
        utility = {
          sleuth.enable = true;
          oil-nvim.enable = true;
        };
        # vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
        # vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
        lsp.enable = true;

        languages = {
          enableTreesitter = true;

          nix.enable = true;
          ts.enable = true;
          rust.enable = true;
        };
      };
    };
  };
}
