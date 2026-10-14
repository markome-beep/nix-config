{ self, inputs, ... }:
{
  flake.nixosModules.git =
    { pkgs, ... }:
    let
      selfPkgs = self.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      environment.systemPackages = [
        selfPkgs.myGit
        selfPkgs.myLazygit
      ];

      # `lg` changes into the directory lazygit was last in when it exits
      programs.bash.interactiveShellInit = ''
        function lg() {
            export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir
            command lazygit "$@"
            if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
              cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
              rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
            fi
        }
      '';
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
        inherit pkgs;

        settings = {
          user.name = "markome-beep";
          user.email = "pirro.marko1@gmail.com";
          init.defaultBranch = "main";
        };
      };

      packages.myLazygit = inputs.wrapper-modules.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.lazygit;

        # Tokyo Night Dark, yaml is a superset of json
        env.LG_CONFIG_FILE = pkgs.writeText "lazygit-config.yml" (
          builtins.toJSON {
            gui.theme = {
              activeBorderColor = [
                "#2ac3de"
                "bold"
              ];
              inactiveBorderColor = [ "#444b6a" ];
              searchingActiveBorderColor = [
                "#787c99"
                "bold"
              ];
              optionsTextColor = [ "#cbccd1" ];
              selectedLineBgColor = [ "#444b6a" ];
              cherryPickedCommitBgColor = [ "#2f3549" ];
              cherryPickedCommitFgColor = [ "#444b6a" ];
              unstagedChangesColor = [ "#c0caf5" ];
              defaultFgColor = [ "#a9b1d6" ];
            };
          }
        );
      };
    };
}
