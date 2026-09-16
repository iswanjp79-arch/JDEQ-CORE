#!/data/data/com.termux/files/usr/bin/bash
set -e
export PREFIX="$HOME/.local"
export BUILD_DIR="$HOME/offline_build"
export PATH="$PREFIX/bin:$PATH"
export LDFLAGS="-L$PREFIX/lib"
export CPPFLAGS="-I$PREFIX/include"
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
export CFLAGS="-fPIC -O2"
export CXXFLAGS="-fPIC -O2"

mkdir -p $BUILD_DIR
cd $BUILD_DIR

pkg install -y git clang make automake autoconf pkg-config wget tar xz unzip ninja

rm -rf cmake-4.2.3 libmd-src

wget https://github.com/Kitware/CMake/releases/download/v4.2.3/cmake-4.2.3.tar.gz
tar xf cmake-4.2.3.tar.gz

git clone https://github.com/NetBSD/src.git libmd-src
cd libmd-src/lib/libmd
./configure --prefix=$PREFIX
make -j$(nproc)
make install
cd $BUILD_DIR

cd cmake-4.2.3
rm -rf CMakeCache.txt CMakeFiles

./bootstrap \
  --prefix=$PREFIX \
  --no-system-libs \
  --parallel=$(nproc)

make -j$(nproc)
make install

cmake --version
echo "CMake full-featured build installed at $PREFIX"
