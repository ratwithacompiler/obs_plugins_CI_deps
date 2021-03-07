curl -kLO https://cdn-fastly.obsproject.com/downloads/dependencies2019.zip -f --retry 5 -C -
7z x dependencies2019.zip -odependencies2019
del dependencies2019.zip

dir
dir dependencies2019

set DepsPath32=%CD%\dependencies2019\win32
set DepsPath64=%CD%\dependencies2019\win64

REM curl -kLO https://cdn-fastly.obsproject.com/downloads/Qt_5.15.2.7z -f --retry 5 -C -
REM 7z x Qt_5.15.2.7z -oQt
REM del Qt_5.15.2.7z
REM set QTDIR32=%CD%\Qt\5.15.2\msvc2019
REM set QTDIR64=%CD%\Qt\5.15.2\msvc2019_64

curl -kLO https://cdn-fastly.obsproject.com/downloads/Qt_5.10.1.7z -f --retry 5 -C -
7z x Qt_5.10.1.7z -oQt
del Qt_5.10.1.7z
set QTDIR32=%CD%\Qt\5.10.1\msvc2017
set QTDIR64=%CD%\Qt\5.10.1\msvc2017_64

dir
dir Qt

set build_config=RelWithDebInfo

git clone --branch master --single-branch https://github.com/obsproject/obs-studio.git obs_src
git reset --hard 3bc4e8ecbab768b3a700aba2d34fc2364179f6f2

cd obs_src
dir

mkdir build_32
cd ./build_32
cmake -G "Visual Studio 16 2019" -A Win32 -DCMAKE_SYSTEM_VERSION=10.0  -DCOPIED_DEPENDENCIES=false -DCOPY_DEPENDENCIES=true ..
cd ..

mkdir build_64
cd ./build_64
cmake -G "Visual Studio 16 2019" -A x64 -DCMAKE_SYSTEM_VERSION=10.0 -DCOPIED_DEPENDENCIES=false -DCOPY_DEPENDENCIES=true ..
cd ..

cd

cd ./build_32
cmake.exe  --build . --config RelWithDebInfo
cd ../


cd ./build_64
cmake.exe  --build . --config RelWithDebInfo
cd ../

if %PRUNE_BUILDS% == YES (
    echo "pruning build dirs"
    mkdir keep_32
    move build_32\UI keep_32
    move build_32\libobs keep_32
    rmdir /Q /S build_32
    move keep_32 build_32

    mkdir keep_64
    move build_64\UI keep_64
    move build_64\libobs keep_64
    rmdir /Q /S build_64
    move keep_64 build_64

    rmdir /Q /S additional_install_files
)

cd ..