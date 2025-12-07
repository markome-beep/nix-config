{pkgs, ...}: {
  programs.bash = {
    enable = true;

    initExtra = ''
      eval "$(starship init bash)"
      
      # if [[ $- =~ i ]] && [[ -z "$TMUX" ]]; then
      #         tmux new-session
      # fi
    '';
  };

  programs.btop.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      format = ''
        ╭$battery$nix_shell$git_branch $directory
        ╰$character
      '';
      line_break.disabled = true;

      nix_shell.format = "\\[[$name]($style)\\]";
      battery = {
        format = "\\[[$symbol$percentage]($style)\\]";
        display = [{threshold = 100;}];
      };
      cmd_duration.format = "\\[[⏱ $duration]($style)\\]";
      time = {
        format = "\\[[$time]($style)\\]";
        disabled = true;
      };
      git_branch.format = "\\[[$symbol$branch]($style)\\]";
      git_status.format = "([\\[$all_status$ahead_behind\\]]($style))";
      rust.format = "\\[[$symbol($version)]($style)\\]";
      package.format = "\\[[$symbol$version]($style)\\]";
      golang.disabled = true;

      # aws.format = "\\[[$symbol($profile)(\\($region\\))(\\[$duration\\])]($style)\\]";
      # bun.format = "\\[[$symbol($version)]($style)\\]";
      # c.format = "\\[[$symbol($version(-$name))]($style)\\]";
      # cpp.format = "\\[[$symbol($version(-$name))]($style)\\]";
      # cmake.format = "\\[[$symbol($version)]($style)\\]";
      # cobol.format = "\\[[$symbol($version)]($style)\\]";
      # conda.format = "\\[[$symbol$environment]($style)\\]";
      # crystal.format = "\\[[$symbol($version)]($style)\\]";
      # daml.format = "\\[[$symbol($version)]($style)\\]";
      # dart.format = "\\[[$symbol($version)]($style)\\]";
      # deno.format = "\\[[$symbol($version)]($style)\\]";
      # docker_context.format = "\\[[$symbol$context]($style)\\]";
      # dotnet.format = "\\[[$symbol($version)(🎯 $tfm)]($style)\\]";
      # elixir.format = "\\[[$symbol($version \\(OTP $otp_version\\))]($style)\\]";
      # elm.format = "\\[[$symbol($version)]($style)\\]";
      # erlang.format = "\\[[$symbol($version)]($style)\\]";
      # fennel.format = "\\[[$symbol($version)]($style)\\]";
      # fossil_branch.format = "\\[[$symbol$branch]($style)\\]";
      # gcloud.format = "\\[[$symbol$account(@$domain)(\\($region\\))]($style)\\]";
      # golang.format = "\\[[$symbol($version)]($style)\\]";
      # gradle.format = "\\[[$symbol($version)]($style)\\]";
      # guix_shell.format = "\\[[$symbol]($style)\\]";
      # haskell.format = "\\[[$symbol($version)]($style)\\]";
      # haxe.format = "\\[[$symbol($version)]($style)\\]";
      # helm.format = "\\[[$symbol($version)]($style)\\]";
      # hg_branch.format = "\\[[$symbol$branch]($style)\\]";
      # java.format = "\\[[$symbol($version)]($style)\\]";
      # julia.format = "\\[[$symbol($version)]($style)\\]";
      # kotlin.format = "\\[[$symbol($version)]($style)\\]";
      # kubernetes.format = "\\[[$symbol$context( \\($namespace\\))]($style)\\]";
      # lua.format = "\\[[$symbol($version)]($style)\\]";
      # memory_usage.format = "\\[$symbol[$ram( | $swap)]($style)\\]";
      # meson.format = "\\[[$symbol$project]($style)\\]";
      # nim.format = "\\[[$symbol($version)]($style)\\]";
      # nodejs.format = "\\[[$symbol($version)]($style)\\]";
      # ocaml.format = "\\[[$symbol($version)(\\($switch_indicator$switch_name\\))]($style)\\]";
      # opa.format = "\\[[$symbol($version)]($style)\\]";
      # openstack.format = "\\[[$symbol$cloud(\\($project\\))]($style)\\]";
      # os.format = "\\[[$symbol]($style)\\]";
      # perl.format = "\\[[$symbol($version)]($style)\\]";
      # php.format = "\\[[$symbol($version)]($style)\\]";
      # pijul_channel.format = "\\[[$symbol$channel]($style)\\]";
      # pixi.format = "\\[[$symbol$version( $environment)]($style)\\]";
      # pulumi.format = "\\[[$symbol$stack]($style)\\]";
      # purescript.format = "\\[[$symbol($version)]($style)\\]";
      # python.format = "\\[[\${symbol}\${pyenv_prefix}(\${version})(\\($virtualenv\\))]($style)\\]";
      # raku.format = "\\[[$symbol($version-$vm_version)]($style)\\]";
      # red.format = "\\[[$symbol($version)]($style)\\]";
      # ruby.format = "\\[[$symbol($version)]($style)\\]";
      # scala.format = "\\[[$symbol($version)]($style)\\]";
      # spack.format = "\\[[$symbol$environment]($style)\\]";
      # sudo.format = "\\[[as $symbol]($style)\\]";
      # swift.format = "\\[[$symbol($version)]($style)\\]";
      # terraform.format = "\\[[$symbol$workspace]($style)\\]";
      # username.format = "\\[[$user]($style)\\]";
      # vagrant.format = "\\[[$symbol($version)]($style)\\]";
      # vlang.format = "\\[[$symbol($version)]($style)\\]";
      # zig.format = "\\[[$symbol($version)]($style)\\]";
      # solidity.format = "\\[[$symbol($version)]($style)\\]";
    };
  };

  programs.zoxide = {
    enableBashIntegration = true;
    enable = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    silent = true;
    # config = {
    #   hide_env_diff = true;
    # };
  };

  programs.git = {
    enable = true;
    userName = "markome-beep";
    userEmail = "pirro.marko1@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.lazygit.enable = true;

  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    newSession = true;
    escapeTime = 0;
    secureSocket = false;
    mouse = true;
    clock24 = true;
    historyLimit = 50000;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };
}
