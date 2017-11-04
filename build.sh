#!/bin/sh

set -eu

# Build zlib
ROOT=`pwd`
PREFIX=$ROOT/prefix
# make -j${PARA}
PARA=6

echo "Mosh Static root (this directory): $ROOT"
echo "Prefix: $PREFIX"
read -p "Press enter to continue"

git submodule update --recursive
git submodule foreach git clean -dfx
rm -rf $PREFIX

export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
export PKG_CONFIG_LIBDIR=$PREFIX/lib/pkgconfig
export PATH=$PREFIX/bin:$PATH
export CFLAGS=
export CXXFLAGS=
export LDFLAGS=
export CPPFLAGS=-P
export ACLOCAL_FLAGS=
export LD_LIBRARY_PATH=

echo "Build zlib"
cd $ROOT/deps/zlib
env CFLAGS=-fPIC ./configure --static --prefix=$PREFIX
make -j${PARA}
make install

ldflags_zlib=`pkg-config --libs-only-L zlib`

echo "Build protobuf"
cd $ROOT/deps/protobuf
./autogen.sh
./configure --with-pic --enable-static --disable-shared --prefix=$PREFIX
make -j${PARA}
make install

echo "Build ncurses"
cd $ROOT/deps
if [ ! -f ncurses.tar.gz ]; then
    wget 'https://invisible-mirror.net/archives/ncurses/ncurses.tar.gz'
fi
rm -rf ncurses-*
tar -zxf ncurses.tar.gz

cd $ROOT/deps/ncurses-*
env CFLAGS=-fPIC ./configure --prefix=$PREFIX --without-shared --enable-widec --enable-pc-files
make -j${PARA}
make install

echo "Build perl"
cd $ROOT/deps
PERL_VER=5.26.1
if [ ! -f perl-${PERL_VER}.tar.gz ]; then
wget "http://www.cpan.org/src/5.0/perl-${PERL_VER}.tar.gz"
fi
rm -rf $ROOT/deps/perl-${PERL_VER}
tar -zxf perl-${PERL_VER}.tar.gz
cd $ROOT/deps/perl-${PERL_VER}
./Configure -des -Dprefix=$PREFIX
make -j${PARA}
make install


echo "Build openssl"
cd $ROOT/deps/openssl
./config --prefix=$PREFIX no-shared
make -j${PARA}
make install

echo "Finally, build mosh with agent forwarding"
cd $ROOT/deps/mosh
./autogen.sh
env "LDFLAGS=${ldflags_zlib} -static" ./configure --prefix=$PREFIX --enable-agent-forwarding
make -j${PARA}
make install
