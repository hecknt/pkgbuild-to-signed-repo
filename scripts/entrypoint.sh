#!/bin/bash

set -oeux pipefail

# debugging
pwd
tree
ls -al
ls -al /github
ls -al /github/workspace

if [ -d "/github" ]; then
sudo chown -R build /github/workspace /github/home
fi

sudo pacman -Syu
export MAKEFLAGS=-j$(nproc)
for f in $(ls pkgs/); do
  pushd pkgs/$f
  namcap PKGBUILD
  su --login builder --command="makepkg -s"
  mv *.pkg.tar.zst ..
  popd
done
