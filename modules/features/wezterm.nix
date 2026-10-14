{ self, inputs, ... }:
{
  flake.nixosModules.wezterm =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myWezterm
      ];

      programs.bash.interactiveShellInit = ''
        source "${pkgs.wezterm}/etc/profile.d/wezterm.sh"
      '';
    };

  perSystem =
    { pkgs, lib, ... }:
    {
      packages.myWezterm = inputs.wrapper-modules.wrappers.wezterm.wrap {
        inherit pkgs;

        luaInfo = {
          enable_tab_bar = false;

          font = lib.generators.mkLuaInline ''wezterm.font_with_fallback { "DejaVu Sans Mono", "Noto Color Emoji" }'';
          font_size = 12;

          # Tokyo Night Dark
          colors = {
            foreground = "#a9b1d6";
            background = "#1a1b26";
            cursor_bg = "#a9b1d6";
            cursor_fg = "#1a1b26";
            compose_cursor = "#cbccd1";
            selection_bg = "#a9b1d6";
            selection_fg = "#1a1b26";
            scrollbar_thumb = "#16161e";
            split = "#444b6a";
            visual_bell = "#a9b1d6";
            ansi = [
              "#1a1b26"
              "#c0caf5"
              "#9ece6a"
              "#0db9d7"
              "#2ac3de"
              "#bb9af7"
              "#b4f9f8"
              "#a9b1d6"
            ];
            brights = [
              "#444b6a"
              "#c0caf5"
              "#9ece6a"
              "#0db9d7"
              "#2ac3de"
              "#bb9af7"
              "#b4f9f8"
              "#d5d6db"
            ];
          };
          command_palette_bg_color = "#16161e";
          command_palette_fg_color = "#a9b1d6";
          command_palette_font_size = 10;
        };
      };
    };
}
