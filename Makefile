X64HOME  := $(shell pwd)/x64
I386HOME := $(shell pwd)/i386

debug:
	echo $(X64HOME)

uninstall: 
	rm -rf x64 i386

all: i386 x64

i386:
	export    CPP="i686-w64-mingw32-cpp"                    \
                  CXX="i686-w64-mingw32-g++      -m32"          \
                   CC="i686-w64-mingw32-gcc      -m32"          \
                   FC="i686-w64-mingw32-gfortran -m32"          \
                  F90="i686-w64-mingw32-gfortran -m32"          \
               RANLIB="i686-w64-mingw32-ranlib"              && \
        cd zlib-1.2.8                                        && \
        test -e Makefile && $(MAKE) distclean || true        && \
        ./configure --static                                    \
                    --prefix=$(I386HOME)                     && \
        $(MAKE) install                                      && \
        cd ../szip-2.1                                       && \
        test -e Makefile && $(MAKE) distclean || true        && \
        ./configure --disable-shared                            \
                    --prefix=$(I386HOME)                        \
                    --host=i686-w64-mingw32                  && \
        $(MAKE) install                                      && \
        cd ../hdf5-1.8.13                                    && \
        test -e Makefile && $(MAKE) distclean || true        && \
        CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB"   \
          LIBS="-lws2_32"                                       \
        ./configure --disable-shared                            \
            --disable-cxx                                       \
            --disable-fortran                                   \
            --enable-static-exec                                \
                --prefix=$(I386HOME)                            \
             --with-zlib=$(I386HOME)                            \
            --with-szlib=$(I386HOME)                            \
            --host=i686-w64-mingw32                          && \
        $(MAKE) install
x64:
	export    CPP=x86_64-w64-mingw32-cpp                   \
                  CXX="x86_64-w64-mingw32-g++      -m64"       \
                   CC="x86_64-w64-mingw32-gcc      -m64"       \
                   FC="x86_64-w64-mingw32-gfortran -m64"       \
                  F90="x86_64-w64-mingw32-gfortran -m64"       \
               RANLIB=x86_64-w64-mingw32-ranlib             && \
        cd zlib-1.2.8                                       && \
        test -e Makefile && $(MAKE) distclean || true       && \
        ./configure --static                                   \
                    --prefix=$(X64HOME)                     && \
        $(MAKE) install                                     && \
        cd ../szip-2.1                                      && \
        test -e Makefile && $(MAKE) distclean || true       && \
        ./configure --disable-shared                           \
                    --prefix=$(X64HOME)                        \
                    --host=x86_64-w64-mingw32               && \
        $(MAKE) install                                     && \
        cd ../hdf5-1.8.13                                   && \
        test -e Makefile && $(MAKE) distclean || true       && \
        CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB"  \
          LIBS="-lws2_32"                                      \
        ./configure --disable-shared                           \
            --disable-cxx                                      \
            --disable-fortran                                  \
            --enable-static-exec                               \
                --prefix=$(X64HOME)                            \
             --with-zlib=$(X64HOME)                            \
            --with-szlib=$(X64HOME)                            \
            --host=x86_64-w64-mingw32                       && \
        $(MAKE) install
test:
	@ \
        $(X64HOME)/bin/h5ls.exe \
            -r $(shell pwd)/hdf5-1.8.13/tools/h5repack/testfiles/h5repack_szip.h5 && \
        $(I386HOME)/bin/h5ls.exe \
            -r $(shell pwd)/hdf5-1.8.13/tools/h5repack/testfiles/h5repack_szip.h5
