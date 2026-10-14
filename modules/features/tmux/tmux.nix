{ self, inputs, ... }:
{
  flake.nixosModules.tmux =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myTmux
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myTmux = inputs.wrapper-modules.wrappers.tmux.wrap {
        inherit pkgs;

        prefix = "C-a";
        baseIndex = 1;
        escapeTime = 0;
        secureSocket = false;
        mouse = true;
        clock24 = true;
        historyLimit = 50000;
        allowPassthrough = false;
        disableConfirmationPrompt = false;

        # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
        terminal = "xterm-256color";

        plugins = with pkgs; [
          tmuxPlugins.better-mouse-mode
        ];

        configBefore = ''
          new-session -A -s 0
        '';

        configAfter = ''
          source-file ${./tokyo-night-dark.conf}

          set -ga terminal-overrides ",*256col*:Tc"
          set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
          set-environment -g COLORTERM "truecolor"

          # easy-to-remember split pane commands
          bind | split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          bind c new-window -c "#{pane_current_path}"
        '';
      };
    };
}
