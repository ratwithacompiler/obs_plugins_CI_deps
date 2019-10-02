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
git clone --branch 23.2.1 --single-branch --depth 1 --recursive https://github.com/obsproject/obs-studio.git obs_src

brew update

#Base OBS Deps and ccache
brew install jack speexdsp ccache mbedtls clang-format
brew install https://gist.githubusercontent.com/DDRBoxman/b3956fab6073335a4bf151db0dcbd4ad/raw/ed1342a8a86793ea8c10d8b4d712a654da121ace/qt.rb
brew install https://gist.githubusercontent.com/DDRBoxman/4cada55c51803a2f963fa40ce55c9d3e/raw/572c67e908bfbc1bcb8c476ea77ea3935133f5b5/swig.rb

export PATH=/usr/local/opt/ccache/libexec:$PATH
ccache -s || echo "CCache is not available."

# Fetch and untar prebuilt OBS deps that are compatible with older versions of OSX
hr "Downloading OBS deps"
wget --quiet --retry-connrefused --waitretry=1 https://obs-nightly.s3.amazonaws.com/osx-deps-2018-08-09.tar.gz

mkdir osx_deps/
tar -xf ./osx-deps-2018-08-09.tar.gz -C osx_deps/

pwd

export PATH=/usr/local/opt/ccache/libexec:$PATH


mkdir obs_src/build
cd obs_src/build

cmake  \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.11 \
-DQTDIR=/usr/local/Cellar/qt/5.10.1 \
-DDepsPath=$PWD/../../osx_deps/obsdeps \
-DENABLE_SCRIPTING=OFF \
-DDISABLE_PYTHON=ON \
-DBUILD_CAPTIONS=ON ..

make -j4

cd ../../
pwd


mv -vn /usr/local/Cellar/qt/5.10.1 qt_dep

mkdir output
mv -vn obs_src qt_dep osx_deps output/
