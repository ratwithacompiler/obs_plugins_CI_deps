set BASE_DIR=%cd%
echo workdir: %cd%
echo VC_INSTALL_PKG: %VC_INSTALL_PKG%
echo VC_COMMIT: %VC_COMMIT%
echo GOOGLE_APIS_COMMIT: %GOOGLE_APIS_COMMIT%
echo

IF NOT DEFINED VC_INSTALL_PKG (
    echo ERROR: missing VC_INSTALL_PKG
    exit 1
)

IF NOT DEFINED VC_COMMIT (
    echo ERROR: missing VC_COMMIT
    exit 1
)

IF NOT DEFINED GOOGLE_APIS_COMMIT (
    echo ERROR: missing GOOGLE_APIS_COMMIT
    exit 1
)

git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
cd

set "triplet=%VC_INSTALL_PKG:*:=%"
set VCPKG_INSTALLED=%cd%\installed\%triplet%
echo VCPKG_INSTALLED: %VCPKG_INSTALLED%

git reset --hard %VC_COMMIT%
cmd /C bootstrap-vcpkg.bat

if %VC_RELEASE_ONLY% == YES (
    echo VC_RELEASE_ONLY, using VCPKG_BUILD_TYPE release
)
if %VC_RELEASE_ONLY% == YES echo.set(VCPKG_BUILD_TYPE release)>> triplets\%triplet%.cmake

vcpkg.exe install %VC_INSTALL_PKG%

echo checking out googleapis repo
git clone --single-branch --branch master https://github.com/googleapis/googleapis
cd googleapis
git reset --hard %GOOGLE_APIS_COMMIT%

mkdir gens
SET SCRIPT_PATH=%~dp0
SET SCRIPT_DIR=%SCRIPT_PATH:~0,-1%
cmake.exe ^
-DGOOGLEAPIS_PATH='%cd%' ^
-DPROTO_INCLUDE_PATH=%VCPKG_INSTALLED%\include ^
-DPROTOC_PATH=%VCPKG_INSTALLED%\tools\protobuf\protoc.exe ^
-DPROTOC_CPP_PATH=%VCPKG_INSTALLED%\tools\grpc\grpc_cpp_plugin.exe ^
-P %SCRIPT_DIR%\CMakeLists.txt
REM
cd
cd ..
cd
dir

mkdir output_dir
move googleapis output_dir\

vcpkg.exe export --x-all-installed --raw --output=output_dir\vcpkg_export
if %VC_RELEASE_ONLY% == YES (
    echo delete output_dir\vcpkg_export\installed\%triplet%\debug
    tree output_dir\vcpkg_export\installed\%triplet%\debug
)

move output_dir ../
cd ..
cd
dir
