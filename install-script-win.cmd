set BASE_DIR=%cd%
echo workdir: %cd%
echo VC_INSTALL_PKG: %VC_INSTALL_PKG%
echo VC_COMMIT: %VC_COMMIT%
echo GOOGLE_APIS_COMMIT: %GOOGLE_APIS_COMMIT%
set VC_Triplet=%VC_INSTALL_PKG:*:=%
echo triplet: %VC_Triplet%
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

set VCPKG_INSTALLED=%cd%\installed\%VC_Triplet%
echo VCPKG_INSTALLED: %VCPKG_INSTALLED%

SET VC_Trip1=triplets\%VC_Triplet%.cmake
SET VC_Trip2=triplets\community\%VC_Triplet%.cmake

echo VC_Trip1: %VC_Trip1%
echo VC_Trip2: %VC_Trip2%

git reset --hard %VC_COMMIT%
cmd /C bootstrap-vcpkg.bat

if %VC_RELEASE_ONLY% == YES (
    echo VC_RELEASE_ONLY, using VCPKG_BUILD_TYPE release

    if exist %VC_Trip1% (
        echo found!!!!!!!!!: %VC_Trip1%
        if %VC_RELEASE_ONLY% == YES (
            echo. >> %VC_Trip1%
            echo.set(VCPKG_BUILD_TYPE release^)>> %VC_Trip1%
        )
        type %VC_Trip1%
    )

    if exist %VC_Trip2% (
        echo found!!!!!!!!!: %VC_Trip2%
        if %VC_RELEASE_ONLY% == YES (
            echo. >> %VC_Trip2%
            echo.set(VCPKG_BUILD_TYPE release^)>> %VC_Trip2%
        )
        type %VC_Trip2%
    )
)

echo installing
.\vcpkg.exe install %VC_INSTALL_PKG%

if %errorlevel% neq 0 (
    echo "error installing"
    exit /b %errorlevel%
)

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
    echo delete output_dir\vcpkg_export\installed\%VC_Triplet%\debug
    tree output_dir\vcpkg_export\installed\%VC_Triplet%\debug
)

move output_dir ../
cd ..
cd
dir
