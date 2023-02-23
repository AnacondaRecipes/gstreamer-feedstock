#!/bin/bash

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig


meson --prefix=${PREFIX} \
      --buildtype=release \
      --libdir=$PREFIX/lib \
      ..
ninja -j${CPU_COUNT}
ninja install

# remove gdb files
rm -rf $PREFIX/share/gdb
rm -rf $PREFIX/share/gstreamer-1.0/gdb