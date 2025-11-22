#!/bin/bash

set -oeux pipefail

if [ -d "/github" ]; then
sudo chown -R build /github/workspace /github/home
fi

# repo directory
mkdir repo

sudo pacman -Syu
export MAKEFLAGS=-j$(nproc)
for f in $(ls pkgs/); do
  pushd pkgs/$f
  namcap PKGBUILD
  su build --command="makepkg -s"
  mv *.pkg.tar.zst ../repo
  popd
done

tree repo
