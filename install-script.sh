#!/bin/bash

set -e

echo --------------------------------------------------------------
echo INSTALL DEPS
echo --------------------------------------------------------------

for arg in "$@"; do
  if [ "$arg" == '--install-deps' ]; then
    echo installing deps
    brew install gcc6
  fi
done

echo --------------------------------------------------------------
echo INSTALL VCPKG
echo --------------------------------------------------------------

if [ ! -d "vcpkg" ]; then
  echo "installing vcpkg"
  git clone https://github.com/Microsoft/vcpkg.git
  cd vcpkg
  git reset --hard 9b72cad7f0c7c3bc364cb471bf624e6cae3e1aef #grpc 1.33.1, protobuf 3.14.0
  ./bootstrap-vcpkg.sh
  echo done
  cd ..
else
  echo "vcpkg exists already, using that"
fi

echo --------------------------------------------------------------
echo INSTALLING GRPC
echo --------------------------------------------------------------

cd vcpkg
./vcpkg install grpc
echo done
VCPKG_DIR="$(pwd)"
pkg_triplet="$(./vcpkg list grpc |egrep -o '^[a-zA-Z0-9:_-]+'| head -n1 | sed 's/^grpc://')"
echo "triplet: $pkg_triplet"

echo --------------------------------------------------------------
echo CREATING GRPC GOOGLEAPIS
echo --------------------------------------------------------------

echo
echo fetching googleapis
if [ ! -d "googleapis" ]; then
  echo checking out repo
  git clone --single-branch --branch master "https://github.com/googleapis/googleapis"
  cd googleapis
  git reset --hard 959b0bcea3f542b8d6964c910b11fb847b12a5ad
  cd ..

  #wget -c "https://github.com/googleapis/googleapis/archive/959b0bcea3f542b8d6964c910b11fb847b12a5ad.zip"
  #unzip 959b0bcea3f542b8d6964c910b11fb847b12a5ad.zip

else
  echo googleapis exists already, skipping checkout
fi
pwd

echo
echo building googleapis

protoc_path="$VCPKG_DIR/installed/$pkg_triplet/tools/protobuf/protoc"
protoc_include="$VCPKG_DIR/installed/$pkg_triplet/include/"
grpc_cpp_path="$VCPKG_DIR/installed/$pkg_triplet/tools/grpc/grpc_cpp_plugin"
echo "protoc_path: $protoc_path"
echo "protoc_include: $protoc_include"
echo "grpc_cpp_path: $grpc_cpp_path"

#mkdir -p gens
#rm -rf gens
cd googleapis
make GRPCPLUGIN="$grpc_cpp_path" PROTOC="$protoc_path" PROTOINCLUDE="$protoc_include" LANGUAGE=cpp clean || true
make GRPCPLUGIN="$grpc_cpp_path" PROTOC="$protoc_path" PROTOINCLUDE="$protoc_include" LANGUAGE=cpp all
cd ../

echo
echo done

echo --------------------------------------------------------------
echo EXPORTING
echo --------------------------------------------------------------

mkdir -p output
mv -vn googleapis output/
./vcpkg export grpc --raw --output=output/vcpkg_export
