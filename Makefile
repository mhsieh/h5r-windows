uninstall:
	rm -rf x64 i386

all: i386 x64

i386:
	@ \
        export    CPP="i686-w64-mingw32-cpp"                  \
                  CXX="i686-w64-mingw32-g++      -m32"        \
                   CC="i686-w64-mingw32-gcc      -m32"        \
                   FC="i686-w64-mingw32-gfortran -m32"        \
                  F90="i686-w64-mingw32-gfortran -m32"        \
               RANLIB="i686-w64-mingw32-ranlib"            && \
        cd zlib-1.2.8                                      && \
        test -e Makefile && $(MAKE) distclean || true      && \
        ./configure --static                                  \
                    --prefix=$$HOME/mingw64/i386           && \
        $(MAKE) install                                    && \
        cd ../szip-2.1                                     && \
        test -e Makefile && $(MAKE) distclean || true      && \
        ./configure --disable-shared                          \
                    --prefix=$$HOME/mingw64/i386              \
                    --host=i686-w64-mingw32                && \
        $(MAKE) install                                    && \
        cd ../hdf5-1.8.13                                  && \
        test -e Makefile && $(MAKE) distclean || true      && \
        CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB" \
          LIBS="-lws2_32"                                     \
        ./configure --disable-shared                          \
            --disable-cxx                                     \
            --disable-fortran                                 \
            --enable-static-exec                              \
                --prefix=$$HOME/mingw64/i386                  \
             --with-zlib=$$HOME/mingw64/i386                  \
            --with-szlib=$$HOME/mingw64/i386                  \
            --host=i686-w64-mingw32                        && \
        $(MAKE) install
x64:
	@ \
        export    CPP=x86_64-w64-mingw32-cpp                  \
                  CXX="x86_64-w64-mingw32-g++      -m64"      \
                   CC="x86_64-w64-mingw32-gcc      -m64"      \
                   FC="x86_64-w64-mingw32-gfortran -m64"      \
                  F90="x86_64-w64-mingw32-gfortran -m64"      \
               RANLIB=x86_64-w64-mingw32-ranlib            && \
        cd zlib-1.2.8                                      && \
        test -e Makefile && $(MAKE) distclean || true      && \
        ./configure --static                                  \
                    --prefix=$$HOME/mingw64/x64            && \
        $(MAKE) install                                    && \
        cd ../szip-2.1                                     && \
        test -e Makefile && $(MAKE) distclean || true      && \
        ./configure --disable-shared                          \
                    --prefix=$$HOME/mingw64/x64               \
                    --host=x86_64-w64-mingw32              && \
        $(MAKE) install                                    && \
        cd ../hdf5-1.8.13                                  && \
        test -e Makefile && $(MAKE) distclean || true      && \
        CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB" \
          LIBS="-lws2_32"                                     \
        ./configure --disable-shared                          \
            --disable-cxx                                     \
            --disable-fortran                                 \
            --enable-static-exec                              \
                --prefix=$$HOME/mingw64/x64                   \
             --with-zlib=$$HOME/mingw64/x64                   \
            --with-szlib=$$HOME/mingw64/x64                   \
            --host=x86_64-w64-mingw32                      && \
        $(MAKE) install
test:
	@ \
        $$HOME/x64/bin/h5ls.exe \
            -r $$HOME/hdf5-1.8.13/tools/h5repack/testfiles/h5repack_szip.h5 && \
        $$HOME/i386/bin/h5ls.exe \
            -r $$HOME/hdf5-1.8.13/tools/h5repack/testfiles/h5repack_szip.h5
