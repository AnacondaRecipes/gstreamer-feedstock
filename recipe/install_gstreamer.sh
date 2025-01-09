#!/bin/bash

mkdir build
pushd build

# Make sure .gir files in $PREFIX are found
export XDG_DATA_DIRS=${XDG_DATA_DIRS}:$PREFIX/share:$BUILD_PREFIX/share
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig


meson --prefix=${PREFIX} \
      --buildtype=release \
      --libdir=$PREFIX/lib \
      -Dintrospection=enabled \
      -Dptp-helper-permissions=none \
      -Dexamples=disabled \
      -Dtests=disabled \
      --wrap-mode=nofallback \
      ..
ninja -j${CPU_COUNT}
ninja install

# remove gdb files
rm -rf $PREFIX/share/gdb
rm -rf $PREFIX/share/gstreamer-1.0/gdb
