#!/usr/bin/env bash
set -e
pushd ~/nixos

# Autoformat your nix files
alejandra . &>/dev/null \
  || ( alejandra . ; echo "formatting failed!" && exit 1)

git add .

echo "NixOS Rebuilding..."
sudo script -q -c "nixos-rebuild switch --flake .#dev-one" /dev/null | tee nixos-rebuild.log

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Commit all changes witih the generation metadata
git commit -m "$current"

popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
