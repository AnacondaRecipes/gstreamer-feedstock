#!/bin/bash

pushd plugins_base

mkdir build
pushd build

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PREFIX/lib/pkgconfig:$BUILD_PREFIX/lib/pkgconfig

meson_options=(
      -Dintrospection=enabled
      -Dexamples=disabled
      -Dtests=disabled
      -Dpackage-origin=https://github.com/AnacondaRecipes/gstreamer-feedstock
)

if [[ “${target_platform}“ == *ppc64le* ]]; then
meson_options+=(
      -Dgl=disabled
)
elif [[ “${target_platform}“ == *s390x* ]]; then
meson_options+=(
      -Dgl=disabled
)
else
meson_options+=(
      -Dgl=enabled
)
fi

if [ -n "$OSX_ARCH" ] ; then
	# disable X11 plugins on macOS
	meson_options+=(-Dx11=disabled)
	meson_options+=(-Dxvideo=disabled)
	meson_options+=(-Dxshm=disabled)
fi

meson --prefix=${PREFIX} \
      --libdir=$PREFIX/lib \
      --buildtype=release \
      --wrap-mode=nofallback \
      "${meson_options[@]}" \
      ..
ninja -j${CPU_COUNT}
ninja install
