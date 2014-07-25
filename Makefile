#################################################################################
# Copyright (c) 2011-2013, Pacific Biosciences of California, Inc.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# * Neither the name of Pacific Biosciences nor the names of its
#   contributors may be used to endorse or promote products derived from
#   this software without specific prior written permission.
#
# NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
# THIS LICENSE.  THIS SOFTWARE IS PROVIDED BY PACIFIC BIOSCIENCES AND ITS
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL PACIFIC BIOSCIENCES OR
# ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#################################################################################
SHELL     = /bin/bash
RTOOLSURL = "http://cran.r-project.org/bin/windows/Rtools/Rtools31.exe"
HDF5URL   = "http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.13.tar.gz"
ZLIBURL   = "http://zlib.net/zlib-1.2.8.tar.gz"
SZLIBURL  = "http://www.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz"
H5RURL    = "https://github.com/extemporaneousb/h5r/archive/master.zip"
H5RURL    = "https://github.com/rforge/h5r/archive/master.zip"
R-PBH5URL = "https://github.com/PacificBiosciences/R-pbh5/archive/master.zip"

nothing:
	@echo nothing

fetchRpbh5:
	$(MAKE) R-pbh5
R-pbh5:
	wget --no-check-certificate $(R-PBH5URL)
	unzip master
	rm -rf R-pbh5 master
	mv R-pbh5-master R-pbh5

fetchh5r:
	$(MAKE) h5r
h5r:
	wget --no-check-certificate $(H5RURL)
	unzip master
	rm -rf h5r master
	mv h5r-master h5r

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

all: h5r_1.4.9.zip

x64zlib:
	@$(MAKE) x64/lib/libz.a
x64/lib/libz.a:
	@cd zlib-1.2.8; \
        env  BINARY_PATH=$$PWD/x64/bin \
            INCLUDE_PATH=$$PWD/x64/include \
            LIBRARY_PATH=$$PWD/x64/lib \
                      CC="gcc -m64" \
                      RC="windres -F pe-x86-64" \
        $(MAKE) -f win32/Makefile.gcc clean install
i386zlib:
	@$(MAKE) i386/lib/libz.a
i386/lib/libz.a:
	@cd zlib-1.2.8; \
        env  BINARY_PATH=$$PWD/i386/bin \
            INCLUDE_PATH=$$PWD/i386/include \
            LIBRARY_PATH=$$PWD/i386/lib \
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
            --prefix=$$PWD/x64 --disable-shared && \
        $(MAKE) install
i386szlib:
	@$(MAKE) i386/lib/libsz.a
i386/lib/libsz.a:
	@cd szip-2.1 && \
        (test -f Makefile && $(MAKE) distclean || true) && \
        env  CC="gcc -m32" \
            CXX="g++ -m32" \
            F77="gfortran -m32" ./configure \
            --prefix=$$PWD/i386 --disable-shared && \
        $(MAKE) install

x64hdf5: x64szlib x64zlib
	@$(MAKE) x64/lib/libhdf5.a
x64/lib/libhdf5.a:
	@cd hdf5-1.8.13 && \
        (test -f Makefile && $(MAKE) distclean || true) && \
        env CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB" \
              LIBS="-lws2_32" \
                CC="gcc -m64" \
               CXX="g++ -m64" \
                FC="gfortran -m64" \
               F77="gfortran -m64" \
        ./configure \
                --prefix=$$PWD/x64 \
             --with-zlib=$$PWD/x64 \
            --with-szlib=$$PWD/x64 \
            --disable-shared --enable-cxx --enable-fortran \
            --enable-static-exec; \
        $(MAKE) install
i386hdf5: i386szlib i386zlib
	@$(MAKE) i386/lib/libhdf5.a
i386/lib/libhdf5.a:
	@cd hdf5-1.8.13 && \
        (test -f Makefile && $(MAKE) distclean || true) && \
        env CFLAGS="-DH5_HAVE_WIN32_API -DH5_BUILT_AS_STATIC_LIB" \
              LIBS="-lws2_32" \
                CC="gcc -m32" \
               CXX="g++ -m32" \
                FC="gfortran -m32" \
               F77="gfortran -m32" \
        ./configure \
                --prefix=$$PWD/i386 \
             --with-zlib=$$PWD/i386 \
            --with-szlib=$$PWD/i386 \
            --disable-shared --enable-cxx --enable-fortran \
            --enable-static-exec; \
        $(MAKE) install

build-h5r: fetchh5r x64hdf5 i386hdf5
	@$(MAKE) h5r_1.4.9.zip
h5r_1.4.9.zip:
	@rm -rf h5r/windows/i386
	@rm -rf h5r/windows/x64
	@cp -a x64 i386 h5r/windows/
	@mkdir -p $$PWD/R
	@export   PATH="/c/Program Files/R/R-3.0.1/bin/x64:/c/Program Files/MiKTeX 2.9/miktex/bin/x64:$$PATH" \
                R_LIBS="$$PWD/R" && \
        R CMD INSTALL --force-biarch --build h5r
