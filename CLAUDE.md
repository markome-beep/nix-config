# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository layout

`~/nixos-config` is a **bare git repo** with two worktrees:

- `dendritic/` (branch `dendritic`): the active config, a rewrite using the dendritic pattern (flake-parts + import-tree). This is what `rebuild` builds by default.
- `main/` (branch `main`): the legacy config (`nixosConfigurations.nixos`, home-manager based, `nixos-modules/` + `home-manager-modules/`). Kept as a reference for things not yet migrated.

Unless told otherwise, work in `dendritic/`.

## Commands

```sh
rebuild                     # sudo nixos-rebuild switch --flake $NIXOS_FLAKE (default ~/nixos-config/dendritic); extra args pass through, e.g. `rebuild --show-trace`
nixos-rebuild build --flake .#dev-one   # build without switching (no sudo)
nix flake check             # evaluate all outputs
nix build .#myNeovim        # build a single wrapped package (any perSystem package: myWezterm, myHyprland, myRofi, myTmux, ...)
nix run .#myWezterm         # try a wrapped program without rebuilding the system
nix flake update            # bump inputs
```

Flakes only see files tracked by git: **`git add` any new file** before building or it will be silently missing.

## Architecture (dendritic/)

- `flake.nix` hands `./modules` to `import-tree`, which imports **every `.nix` file under `modules/` as a flake-parts module**. Files or directories whose name starts with `_` are skipped; that's how plain NixOS/nvf modules (`_hardware-configuration.nix`, `neovim/_nvf-config.nix`) are kept out and imported explicitly instead.
- Each feature file in `modules/features/` usually defines two things:
  - `flake.nixosModules.<feature>`: the NixOS side (enable services, add the package to `environment.systemPackages`, session vars).
  - `perSystem.packages.my<Name>`: the program with its config baked in, built with `inputs.wrapper-modules` (BirdeeHub/nix-wrapper-modules), either `wrappers.<prog>.wrap { ... }` or `lib.wrapPackage { package = ...; env/flags = ...; }`. NixOS modules reference these via `self.packages.${pkgs.stdenv.hostPlatform.system}.myX`.
- **There is no home-manager here.** User config lives in wrapped packages rather than dotfiles in `$HOME`.
- Adding a feature file doesn't enable it. The host opts in by listing `self.nixosModules.<feature>` in `modules/hosts/dev-one/configuration.nix`. `modules/hosts/dev-one/default.nix` defines `nixosConfigurations.dev-one`.
- Hyprland is configured in Lua (`modules/features/hyprland/hyprland.lua`, passed via `HYPRLAND_CONFIG`). Programs it launches by name must be in `runtimePkgs` in `hyprland.nix` so the wrapped versions come first on PATH. greetd runs the `start-hyprland` wrapper variant, which carries the same environment.
- Custom shell commands go in the `commands` attrset in `modules/features/commands.nix`; each entry becomes a `writeShellApplication` of that name.
- Theme is Tokyo Night Dark everywhere: stylix's base16 scheme, plus hex colors hardcoded in the individual wrappers (wezterm, lazygit, tmux/btop/rofi/swaync theme files). Keep new configs consistent with it.

## Secrets

agenix. `secrets/agenix-rules.nix` lists recipient keys per `.age` file (agenix finds it from `secrets/` or any parent); the system decrypts with `/home/markome/.ssh/id_ed25519`. `github-token.age` is used as `nix.settings.access-tokens`. Edit with `agenix -e github-token.age` from inside `secrets/`.
