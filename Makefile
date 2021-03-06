# THIS IS THE MAKEFILE FOR CROSS-COMPILING HDF5 FOR MINGW32/MINGW-W64 UNDER
# TRAVIS CI ENVIRONMENT
# AUTHOR: Mengjuei Hsieh
# LICENSE: Public Domain

SRC      := $(shell pwd)
X64HOME  := $(SRC)/x64
I386HOME := $(SRC)/i386

debug:
	@echo X64HOME  = $(X64HOME)
	@echo I386HOME = $(I386HOME)
	@ls -l /usr/lib/gcc/i686-w64-mingw32/4.6/
	@ls -l /usr/lib/gcc/x86_64-w64-mingw32/4.6/

clean: uninstall
uninstall: 
	rm -rf x64 i386

all: i386 x64

i386:
	@export   CPP="i686-w64-mingw32-cpp"                             \
                  CXX="i686-w64-mingw32-g++      -m32"                   \
                   CC="i686-w64-mingw32-gcc      -m32"                   \
                   FC="i686-w64-mingw32-gfortran -m32"                   \
                  F90="i686-w64-mingw32-gfortran -m32"                   \
               RANLIB="i686-w64-mingw32-ranlib"                       && \
        cd $$HOME/.wine/drive_c/windows                               && \
        rm -f libstdc++-6.dll libgcc_s_sjlj-1.dll                        \
              libgfortran-3.dll libquadmath-0.dll                     && \
        ln -s /usr/lib/gcc/i686-w64-mingw32/4.6/libstdc++-6.dll       && \
        ln -s /usr/lib/gcc/i686-w64-mingw32/4.6/libgcc_s_sjlj-1.dll   && \
        ln -s /usr/lib/gcc/i686-w64-mingw32/4.6/libgfortran-3.dll     && \
        ln -s /usr/lib/gcc/i686-w64-mingw32/4.6/libquadmath-0.dll     && \
        cd $(SRC)/zlib-1.2.8                                          && \
        test -e Makefile && $(MAKE) distclean || true                 && \
        ./configure                                                      \
            --static                                                     \
            --prefix=$(I386HOME) >> $(SRC)/config.log 2>&1            && \
        $(MAKE) install                                               && \
        cd ../szip-2.1                                                && \
        test -e Makefile && $(MAKE) distclean || true                 && \
        ./configure                                                      \
            --disable-shared                                             \
            --prefix=$(I386HOME)                                         \
            --host=i686-w64-mingw32 >> $(SRC)/config.log 2>&1         && \
        $(MAKE) install                                               && \
        cd ../hdf5-1.8.13                                             && \
        test -e Makefile && $(MAKE) distclean || true                 && \
        CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB"            \
          LIBS="-lws2_32"                                                \
        ./configure                                                      \
            --disable-shared                                             \
            --enable-cxx                                                 \
            --enable-fortran                                             \
            --enable-static-exec                                         \
                --prefix=$(I386HOME)                                     \
             --with-zlib=$(I386HOME)                                     \
            --with-szlib=$(I386HOME)                                     \
            --host=i686-w64-mingw32 >> $(SRC)/config.log 2>&1         && \
        $(MAKE) install
x64:
	@export   CPP=x86_64-w64-mingw32-cpp                             \
                  CXX="x86_64-w64-mingw32-g++      -m64"                 \
                   CC="x86_64-w64-mingw32-gcc      -m64"                 \
                   FC="x86_64-w64-mingw32-gfortran -m64"                 \
                  F90="x86_64-w64-mingw32-gfortran -m64"                 \
               RANLIB=x86_64-w64-mingw32-ranlib                       && \
        cd $$HOME/.wine/drive_c/windows                               && \
        rm -f libstdc++-6.dll libgcc_s_sjlj-1.dll                        \
              libgfortran-3.dll libquadmath-0.dll                     && \
        ln -s /usr/lib/gcc/x86_64-w64-mingw32/4.6/libstdc++-6.dll     && \
        ln -s /usr/lib/gcc/x86_64-w64-mingw32/4.6/libgcc_s_sjlj-1.dll && \
        ln -s /usr/lib/gcc/x86_64-w64-mingw32/4.6/libgfortran-3.dll   && \
        ln -s /usr/lib/gcc/x86_64-w64-mingw32/4.6/libquadmath-0.dll   && \
        cd $(SRC)/zlib-1.2.8                                          && \
        test -e Makefile && $(MAKE) distclean || true                 && \
        ./configure                                                      \
            --static                                                     \
            --prefix=$(X64HOME) >> $(SRC)/config.log 2>&1             && \
        $(MAKE) install                                               && \
        cd ../szip-2.1                                                && \
        test -e Makefile && $(MAKE) distclean || true                 && \
        ./configure                                                      \
            --disable-shared                                             \
            --prefix=$(X64HOME)                                          \
            --host=x86_64-w64-mingw32 >> $(SRC)/config.log 2>&1       && \
        $(MAKE) install                                               && \
        cd ../hdf5-1.8.13                                             && \
        test -e Makefile && $(MAKE) distclean || true                 && \
        CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB"            \
          LIBS="-lws2_32"                                                \
        ./configure                                                      \
            --disable-shared                                             \
            --enable-cxx                                                 \
            --enable-fortran                                             \
            --enable-static-exec                                         \
                --prefix=$(X64HOME)                                      \
             --with-zlib=$(X64HOME)                                      \
            --with-szlib=$(X64HOME)                                      \
            --host=x86_64-w64-mingw32 >> $(SRC)/config.log 2>&1       && \
        $(MAKE) install
test:
	@ \
        $(X64HOME)/bin/h5ls.exe                                                \
            -r $(SRC)/hdf5-1.8.13/tools/h5repack/testfiles/h5repack_szip.h5    \
            2>&1                                                            && \
        $(I386HOME)/bin/h5ls.exe                                               \
            -r $(SRC)/hdf5-1.8.13/tools/h5repack/testfiles/h5repack_szip.h5    \
            2>&1
