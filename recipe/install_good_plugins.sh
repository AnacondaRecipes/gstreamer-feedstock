#!/bin/bash

pushd plugins_good

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

meson_options=(
      -Dexamples=disabled
      -Dtests=disabled
      -Dpackage-origin=https://github.com/AnacondaRecipes/gstreamer-feedstock
)

if [ $(uname) = "Linux" ] ; then
	# v4l2 contains clock_gettime, resulting in linker error
	meson_options+=(-Dv4l2=disabled)
fi

meson --prefix=${PREFIX} \
      --buildtype=release \
      --libdir=$PREFIX/lib \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install
