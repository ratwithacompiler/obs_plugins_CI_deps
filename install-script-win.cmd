
dir
tree

mkdir build
cd build

cmake .. -A X64 -DVCPKG_TARGET_TRIPLET=x64-windows-static ^
-DCMAKE_TOOLCHAIN_FILE=../grpc_deps_x64_static/vcpkg_export/scripts/buildsystems/vcpkg.cmake ^
-DBUILD_SHARED_LIBS=OFF

echo building
cmake --build . --config Release
dir

cd ..
