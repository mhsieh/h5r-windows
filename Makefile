clean: x64clean i386clean
i386clean:
	rm -rf i386/bin
	rm -rf i386/lib
	rm -rf i386/include
	rm -rf i386/share
x64clean:
	rm -rf x64/bin
	rm -rf x64/lib
	rm -rf x64/include
	rm -rf x64/share

all: x64 i386

x64: \
	x64zlib \
	x64szlib
i386: \
	i386zlib \
	i386szlib

x64zlib:
	@$(MAKE) x64/lib/libz.a
x64/lib/libz.a:
	@cd zlib-1.2.8; \
        env  BINARY_PATH=$$HOME/Works/extemporaneousb/x64/bin \
            INCLUDE_PATH=$$HOME/Works/extemporaneousb/x64/include \
            LIBRARY_PATH=$$HOME/Works/extemporaneousb/x64/lib \
                      CC="gcc -m64" \
                      RC="windres -F pe-x86-64" \
        $(MAKE) -f win32/Makefile.gcc clean install
i386zlib:
	@$(MAKE) i386/lib/libz.a
i386/lib/libz.a:
	@cd zlib-1.2.8; \
        env  BINARY_PATH=$$HOME/Works/extemporaneousb/i386/bin \
            INCLUDE_PATH=$$HOME/Works/extemporaneousb/i386/include \
            LIBRARY_PATH=$$HOME/Works/extemporaneousb/i386/lib \
                      CC="gcc -m32" \
                      RC="windres -F pe-i386" \
        $(MAKE) -f win32/Makefile.gcc clean install

x64szlib:
	@$(MAKE) x64/lib/libsz.a
x64/lib/libsz.a:
	@cd szip-2.1 && \
        (test -f Makefile && $(MAKE) distclean || true) && \
        env  CC="gcc -m64" \
            CXX="g++ -m64" \
            F77="gfortran -m64" ./configure \
            --prefix=$$HOME/Works/extemporaneousb/x64 --disable-shared && \
        $(MAKE) install
i386szlib:
	@$(MAKE) i386/lib/libsz.a
i386/lib/libsz.a:
	@cd szip-2.1 && \
        (test -f Makefile && $(MAKE) distclean || true) && \
        env  CC="gcc -m32" \
            CXX="g++ -m32" \
            F77="gfortran -m32" ./configure \
            --prefix=$$HOME/Works/extemporaneousb/i386 --disable-shared && \
        $(MAKE) install

i386hdf5:
	cd hdf5-1.8.13 && \
        (test -f Makefile && $(MAKE) distclean || true) && \
        env CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB" \
              LIBS="-lws2_32" \
                CC="gcc -m32" \
               CXX="g++ -m32" \
                FC="gfortran -m32" \
               F77="gfortran -m32" \
       ./configure \
               --prefix=$$HOME/Works/extemporaneousb/i386 \
            --with-zlib=$$HOME/Works/extemporaneousb/i386 \
           --with-szlib=$$HOME/Works/extemporaneousb/i386 \
           --disable-shared --enable-cxx --enable-fortran \
           --enable-static-exec; \
       $(MAKE)