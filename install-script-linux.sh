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

# just clone the version tag we care about
git clone --branch LinuxCaptionFix --single-branch --depth 1 --recursive https://github.com/ioangogo/obs-studio.git obs_src

hr "install CI deps"
./obs_src/CI/install-dependencies-linux.sh

cd obs_src
mkdir build
cd build

cmake .. -DBUILD_CAPTIONS=ON -DUNIX_STRUCTURE=1
make -j4

cd ../../
pwd

mkdir output
mv -vn obs_src output/


