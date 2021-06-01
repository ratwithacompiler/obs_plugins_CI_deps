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

git reset --hard 27.0.0
git submodule update --init --recursive

hr "install CI deps"
./CI/install-dependencies-linux.sh || true #ignore error because of failed CEF download attempt

mkdir build
cd build

cmake .. -DUNIX_STRUCTURE=1 -DENABLE_PIPEWIRE=OFF -DBUILD_BROWSER=OFF
make -j4

cd ../../
pwd

mkdir output
mv -vn obs_src output/


