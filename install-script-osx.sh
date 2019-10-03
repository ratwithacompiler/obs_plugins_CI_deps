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

for arg in "$@"; do
    if [ "$arg" == '--install-deps' ]; then
        echo installing deps;
        brew install gcc6
    fi
done


if [ ! -d "vcpkg" ]; then
    echo "install vcpkg"
    git clone https://github.com/Microsoft/vcpkg.git
    cd vcpkg
    git reset --hard a528ee4b856d0d73b6b837dfa7ab2e745d02b5ca #grpc 1.23.1, protobuf 3.10.0
    ./bootstrap-vcpkg.sh
    echo done
    cd ..
fi

cd vcpkg

echo
echo installing grpc
./vcpkg install grpc
echo done

echo
echo fetching googleapis

protoc_path="$(pwd)/installed/x64-osx/tools/protobuf/protoc"
protoc_include="$(pwd)/installed/x64-osx/include/"

grpc_cpp_path="$(pwd)/installed/x64-osx/tools/grpc/grpc_cpp_plugin"

echo "protoc_path = $protoc_path"
echo "protoc_include = $protoc_include"
echo "grpc_cpp_path = $grpc_cpp_path"



if [ ! -d "googleapis" ]; then
    echo checking out repo
    git clone --single-branch --branch "master" "https://github.com/googleapis/googleapis"

    cd googleapis
    git reset --hard a1b85caabafb4669e5b40ef38b7d663856ab50f9
    pwd

    #wget -c "https://github.com/googleapis/googleapis/archive/a1b85caabafb4669e5b40ef38b7d663856ab50f9.zip"
    #unzip a1b85caabafb4669e5b40ef38b7d663856ab50f9.zip

else
   echo skipping checkout, exists already
   cd googleapis
   pwd
fi
echo
echo
echo making googleapis

#mkdir -p gens
#rm -rf gens

make GRPCPLUGIN="$grpc_cpp_path" PROTOC="$protoc_path" PROTOINCLUDE="$protoc_include" LANGUAGE=cpp clean || true
make GRPCPLUGIN="$grpc_cpp_path" PROTOC="$protoc_path" PROTOINCLUDE="$protoc_include" LANGUAGE=cpp all

cd ../
echo
echo done


mkdir output
mv -vn googleapis output/
mv -vn installed/x64-osx output/
