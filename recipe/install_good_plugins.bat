@ECHO ON

:: set pkg-config path so that host deps can be found
:: (set as env var so it's used by both meson and during build with g-ir-scanner)
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"

:: get mixed path (forward slash) form of prefix so host prefix replacement works
set "LIBRARY_PREFIX_M=%LIBRARY_PREFIX:\=/%"

:: Same gettext/intl linkage issue as gstreamer core: GLib is built with
:: gettext support even though this module's own nls option is disabled,
:: so any TU using <glib/gi18n.h> (here: tools/gst-play.c) still needs
:: intl.lib at link time.
set "LDFLAGS=%LDFLAGS% %LIBRARY_LIB%\intl.lib"

cd plugins_good

%BUILD_PREFIX%\Scripts\meson.exe setup builddir ^
--wrap-mode=nofallback ^
--buildtype=release ^
--prefix=%LIBRARY_PREFIX_M% --backend=ninja ^
-Dexamples=disabled ^
-Dtests=disabled ^
-Dpackage-origin=https://github.com/AnacondaRecipes/gstreamer-feedstock
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1

del %LIBRARY_PREFIX%\bin\*.pdb
