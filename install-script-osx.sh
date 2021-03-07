#!/bin/bash

hr() {
  echo "───────────────────────────────────────────────────"
  echo $1
  echo "───────────────────────────────────────────────────"
}

# Exit if something fails
set -e

# Echo all commands before executing
set -v

pwd

git clone --branch master --single-branch https://github.com/obsproject/obs-studio.git obs_src
cd obs_src

git reset --hard 3bc4e8ecbab768b3a700aba2d34fc2364179f6f2
git submodule update --init --recursive


mkdir build
cd build
# QT 5.14 for OBS 26 compatibility
QT_VERSION="5.14.1" MACOS_DEPS_VERSION="2020-08-30" TERM="" ../CI/full-build-macos.sh
cd ..

cd ..
mv -vn /tmp/obsdeps ./osx_deps

mkdir output
mv -vn obs_src osx_deps output/
