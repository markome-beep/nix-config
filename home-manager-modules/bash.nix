{
  programs.bash = {
    enable = true;

    initExtra = ''
        source ${toString ./init.bash}
    '';
  };
}
