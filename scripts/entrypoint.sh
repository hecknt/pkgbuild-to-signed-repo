#!/bin/bash

set -oeux pipefail

# Import GPG key to sign with
if [ ! -z "${GPG_KEY_DATA-}" ]; then
    if [ -z "${GPG_KEY_ID-}" ]; then
        echo 'GPG_KEY_ID is not set, but GPG_KEY_DATA is set. Please set GPG_KEY_ID to the key ID of the key.'
        exit 1
    fi
    gpg --import /dev/stdin <<<"${GPG_KEY_DATA}"
fi

gpg --recv-keys "${GPG_KEY_ID}"

if [ -d "/github" ]; then
sudo chown -R build /github/workspace /github/home
fi

# repo directory
mkdir repo

sudo pacman -Syu
export MAKEFLAGS=-j$(nproc)

# Build all PKGBUILDs in any folder inside of ./pkgs/
for f in $(ls pkgs/); do
  pushd pkgs/$f
  namcap PKGBUILD
  su build --command="makepkg -s --noconfirm"
  mv *.pkg.tar.zst ../../repo
  popd
done

tree repo

# Generate repository
find repo -type f -iname '*.pkg.tar*' -not -iname '*.sig' -print -exec gpg --batch --yes --detach-sign --use-agent -u "${GPG_KEY_ID}" {} \;
find repo -type f -iname '*.pkg.tar*' -not -iname '*.sig' -print0 | xargs -0 repo-add -k "${GPG_KEY_ID}" -s -v repo/repo.db.tar.zst
