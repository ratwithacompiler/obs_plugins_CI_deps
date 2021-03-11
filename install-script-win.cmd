
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg

git reset --hard 4783c36f8c04f584ec4d232958afae9d32bc61d5
cmd /C bootstrap-vcpkg.bat

.\vcpkg.exe install grpc:x64-windows-static-md




