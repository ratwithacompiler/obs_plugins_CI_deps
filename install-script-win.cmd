if exist dependencies2017.zip (curl -kLO https://cdn-fastly.obsproject.com/downloads/dependencies2017.zip -f --retry 5 -z dependencies2017.zip) else (curl -kLO https://cdn-fastly.obsproject.com/downloads/dependencies2017.zip -f --retry 5 -C -)
7z x dependencies2017.zip -odependencies2017

dir
dir dependencies2017

set DepsPath32=%CD%\dependencies2017\win32
set DepsPath64=%CD%\dependencies2017\win64

del dependencies2017.zip

curl -kLO https://cdn-fastly.obsproject.com/downloads/Qt_5.10.1.7z -f --retry 5 -C -
7z x Qt_5.10.1.7z -oQt
del Qt_5.10.1.7z

dir
dir Qt

set QTDIR32=%CD%\Qt\5.10.1\msvc2017
set QTDIR64=%CD%\Qt\5.10.1\msvc2017_64

set build_config=RelWithDebInfo

:: just clone the version tag we care about
git clone --branch 24.0.4 --single-branch --depth 1 --recursive https://github.com/obsproject/obs-studio.git obs_src
cd obs_src
dir

mkdir build_32 build_64

cd ./build_32
cmake -G "Visual Studio 15 2017" -DCOPIED_DEPENDENCIES=false -DCOPY_DEPENDENCIES=true -DBUILD_CAPTIONS=true ..
cd ..

cd ./build_64
cmake -G "Visual Studio 15 2017 Win64" -DCOPIED_DEPENDENCIES=false -DCOPY_DEPENDENCIES=true -DBUILD_CAPTIONS=true ..
cd ..

dir
cd ..
