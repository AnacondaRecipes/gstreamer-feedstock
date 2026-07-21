@ECHO ON

:: set pkg-config path so that host deps can be found
:: (set as env var so it's used by both meson and during build with g-ir-scanner)
set "PKG_CONFIG_PATH=%LIBRARY_LIB%\pkgconfig;%LIBRARY_PREFIX%\share\pkgconfig;%BUILD_PREFIX%\Library\lib\pkgconfig"

:: get mixed path (forward slash) form of prefix so host prefix replacement works
set "LIBRARY_PREFIX_M=%LIBRARY_PREFIX:\=/%"

:: Even with -Dnls=disabled for gstreamer itself, GLib on this build was
:: compiled with gettext support (proxy-libintl), so any TU that includes
:: <glib/gi18n.h> and calls _() (only tools/gst-inspect.c does) still
:: references g_libintl_gettext/g_libintl_ngettext at link time. Link
:: against intl.lib explicitly so those symbols resolve regardless of
:: gstreamer's own nls option.
set "LDFLAGS=%LDFLAGS% %LIBRARY_LIB%\intl.lib"

meson builddir --wrap-mode=nofallback ^
 --buildtype=release ^
 --prefix=%LIBRARY_PREFIX_M% --backend=ninja ^
 -Dexamples=disabled ^
 -Dintrospection=enabled ^
 -Dnls=disabled ^
 -Dtests=disabled ^
 -Dpackage-origin=https://github.com/AnacondaRecipes/gstreamer-feedstock
if errorlevel 1 exit 1

ninja -v -C builddir -j %CPU_COUNT%
if errorlevel 1 exit 1

ninja -C builddir install -j %CPU_COUNT%
if errorlevel 1 exit 1

del %LIBRARY_PREFIX%\bin\*.pdb
