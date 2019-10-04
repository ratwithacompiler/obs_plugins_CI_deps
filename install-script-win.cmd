set BASE_DIR=%cd%

echo "workdir %cd%"

git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
cd

REM #grpc 1.23.0, protobuf 3.9.1
git reset --hard 02dd1ccd62acd15747f7a6a376cecde782f0fdda

REM #grpc 1.23.1, protobuf 3.10.0
REM git reset --hard a528ee4b856d0d73b6b837dfa7ab2e745d02b5ca

cmd /C bootstrap-vcpkg.bat

vcpkg.exe install grpc:x64-windows grpc:x64-windows-static grpc:x86-windows grpc:x86-windows-static
REM vcpkg.exe install grpc:x64-windows-static
REM .\vcpkg.exe install zlib:x64-windows-static

set VCPKG_INSTALLED=%cd%\installed\x64-windows-static





echo checking out repo
git clone --single-branch --branch "master" "https://github.com/googleapis/googleapis"

cd googleapis
git reset --hard a1b85caabafb4669e5b40ef38b7d663856ab50f9
REM git reset --hard d9576d95b44f64fb0e3da4760adfc4a24fa1faab


mkdir gens

SET SCRIPT_PATH=%~dp0
SET SCRIPT_DIR=%SCRIPT_PATH:~0,-1%
cmake.exe ^
-DGOOGLEAPIS_PATH='%cd%' ^
-DPROTO_INCLUDE_PATH=%VCPKG_INSTALLED%\include ^
-DPROTOC_PATH=%VCPKG_INSTALLED%\tools\protobuf\protoc.exe ^
-DPROTOC_CPP_PATH=%VCPKG_INSTALLED%\tools\grpc\grpc_cpp_plugin.exe ^
-P "%SCRIPT_DIR%\CMakeLists.txt"

cd
cd ..
cd
dir



mkdir output_dir
move googleapis output_dir\

move installed\x64-windows output_dir
move installed\x64-windows-static output_dir

move installed\x86-windows output_dir
move installed\x86-windows-static output_dir

move output_dir ../
cd ..
cd
dir
