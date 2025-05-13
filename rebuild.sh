#!/usr/bin/env bash
set -e
pushd ~/nixos
alejandra . &>/dev/null

git diff -U0 '*.nix'

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."
sudo nixos-rebuild switch --flake ~/nixos#dev-one \
  &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -am "$current"

popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
