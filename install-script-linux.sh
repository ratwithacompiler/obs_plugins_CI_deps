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

hr "install CI deps"
./CI/install-dependencies-linux.sh || true #ignore error because of failed CEF download attempt

mkdir build
cd build

cmake .. -DUNIX_STRUCTURE=1
make -j4

cd ../../
pwd

mkdir output
mv -vn obs_src output/


