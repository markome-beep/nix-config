{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        enable_tab_bar = false,
      }
    '';
  };
}
